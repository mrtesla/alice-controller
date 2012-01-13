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

    bust_cache!
  end

  def remove_from_redis
    REDIS.del "alice.http|flags:#{self.name}"
  end

  def resolved_http_path_rules
    release = self.active_core_release
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

end
