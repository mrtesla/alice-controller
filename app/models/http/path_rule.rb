class Http::PathRule < ActiveRecord::Base

  serialize :actions, JSON

  validates :owner_id,
    presence: true
  validates :owner_type,
    presence: true

  validates :path,
    presence:   true,
    uniqueness: { scope: [:owner_type, :owner_id] }

  validates :actions,
    presence: true

  belongs_to :owner, polymorphic: true
  # belongs_to :core_application,
  #   class_name:  'Core::Application',
  #   foreign_key: 'core_application_id'

  default_scope order(:path)

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def ui_name
    path
  end

  def self.send_to_redis
    Core::Application.all.each do |application|
      send_to_redis_for_application(application)
    end
  end

  def self.send_to_redis_for_application(application)
    values = []

    application.http_path_rules.each do |rule|
      values.push rule.path
      values.push JSON.dump([rule.id, rule.actions])
    end

    REDIS.multi do
      REDIS.del   "alice.http|paths:#{application.name}"
      unless values.empty?
        REDIS.hmset "alice.http|paths:#{application.name}", *values
      end
    end

    application.bust_cache!
  end

private

  def send_to_redis
    self.class.send_to_redis_for_application(self.owner)
  end

end
