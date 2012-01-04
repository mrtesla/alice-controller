class Http::PathRule < ActiveRecord::Base

  serialize :actions, JSON

  validates :core_application_id,
    presence: true

  validates :path,
    presence:   true,
    uniqueness: { scope: :core_application_id }

  validates :actions,
    presence: true

  belongs_to :core_application,
    class_name:  'Core::Application',
    foreign_key: 'core_application_id'

  default_scope order(:path)

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    Core::Application.all.each do |application|
      send_to_redis_for_application(application)
    end
  end

  def self.send_to_redis_for_application(application)
    values = []

    where(core_application_id: application.id).each do |rule|
      values.push rule.path
      values.push JSON.dump([rule.id, rule.actions])
    end

    REDIS.multi do
      REDIS.del   "alice.http|paths:#{application.name}"
      unless values.empty?
        REDIS.hmset "alice.http|paths:#{application.name}", *values
      end
    end
  end

  def request_count(start, window)
    start  = start.to_i
    rem    = start % window
    start -= rem

    REDIS.hget("alice.stats|paths|reqs", "#{self.id}|#{start}|#{window}") || 0
  end

  def rpm(start, window)
    request_count(start, window).to_f / (window / 60)
  end

private

  def send_to_redis
    self.class.send_to_redis_for_application(self.core_application)
  end

end
