class Core::Application < ActiveRecord::Base

  validates :name,
    presence:   true,
    uniqueness: true

  belongs_to :active_core_release,
    class_name:  'Core::Release',
    foreign_key: 'active_core_release_id'

  has_many :core_releases,
    class_name:  'Core::Release',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  has_many :http_backends,
    class_name:  'Http::Backend',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  has_many :http_path_rules,
    class_name:  'Http::PathRule',
    dependent:   :destroy,
    as:          :owner

  has_many :http_domain_rules,
    class_name:  'Http::DomainRule',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  has_many :pluto_environment_variables,
    class_name:  'Pluto::EnvironmentVariable',
    dependent:   :destroy,
    as:          :owner

  has_many :pluto_process_definitions,
    class_name:  'Pluto::ProcessDefinition',
    dependent:   :destroy,
    as:          :owner

  default_scope order(:name)

  after_save    :send_to_redis
  after_destroy :remove_from_redis

  def self.send_to_redis
    all.each do |app|
      app.send_to_redis
    end
  end

  def bust_cache!
    REDIS.hincrby "alice.http|flags:#{self.name}", "cache_version", '1'
  end

  def send_to_redis
    if suspended_mode?
      REDIS.hset "alice.http|flags:#{self.name}", "suspended", "1"
    else
      REDIS.hdel "alice.http|flags:#{self.name}", "suspended"
    end

    if maintenance_mode?
      REDIS.hset "alice.http|flags:#{self.name}", "maintenance", "1"
    else
      REDIS.hdel "alice.http|flags:#{self.name}", "maintenance"
    end

    Http::PathRule.send_to_redis_for_application(self)

    bust_cache!
  end

  def remove_from_redis
    REDIS.del "alice.http|flags:#{self.name}"
  end

  def resolved_http_path_rules(release=nil)
    release = self.active_core_release unless release
    paths   = {}

    if release
      release.http_path_rules.each do |rule|
        paths[rule.path] = rule
      end
    end

    self.http_path_rules.each do |rule|
      paths[rule.path] = rule
    end

    paths.values.sort_by(&:path)
  end

  def resolved_pluto_environment_variables(release=nil)
    release = self.active_core_release unless release
    env     = {}

    if release
      release.pluto_environment_variables.each do |var|
        env[var.name] = var
      end

      env['ALICE_RELEASE'] = Pluto::EnvironmentVariable.new(
        name:  'ALICE_RELEASE',
        value: release.number.to_s
      )
    end

    self.pluto_environment_variables.each do |var|
      env[var.name] = var
    end

    env['ALICE_APPLICATION'] = Pluto::EnvironmentVariable.new(
      name:  'ALICE_APPLICATION',
      value: self.name
    )

    env.values.sort_by(&:name)
  end

  def resolved_pluto_process_definitions(release=nil)
    release = self.active_core_release unless release
    definitions = {}

    if release
      release.pluto_process_definitions.each do |definition|
        definitions[definition.name] = definition
      end
    end

    self.pluto_process_definitions.each do |definition|
      if definitions.key?(definition.name)
        target = definitions[definition.name]
        target.concurrency = definition.concurrency
      else
        definitions[definition.name] = definition
      end
    end

    definitions.values.sort_by(&:name)
  end
end
