class Core::Application < ActiveRecord::Base

  validates :name,
    presence:   true,
    uniqueness: true

  has_many :http_backends,
    class_name:  'Http::Backend',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  has_many :http_path_rules,
    class_name:  'Http::PathRule',
    foreign_key: 'core_application_id',
    dependent:   :destroy

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

  def send_to_redis
    if maintenance_mode?
      REDIS.set "alice.http|applications:#{self.name}|maintenance_mode", "1"
    else
      REDIS.del "alice.http|applications:#{self.name}|maintenance_mode"
    end
  end

  def remove_from_redis
    REDIS.del "alice.http|applications:#{self.name}|maintenance_mode"
  end

end
