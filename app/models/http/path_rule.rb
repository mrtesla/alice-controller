class Http::PathRule < ActiveRecord::Base

  serialize :actions, JSON

  validates :application_id,
    presence: true

  validates :path,
    presence:   true,
    uniqueness: { scope: :application_id }

  validates :actions,
    presence: true

  belongs_to :application

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    Http::Application.all.each do |application|
      send_to_redis_for_application(application)
    end
  end

  def self.send_to_redis_for_application(application)
    values = []

    where(application_id: application.id).each do |rule|
      values.push rule.path
      values.push rule.actions_before_type_cast
    end

    REDIS.multi do
      REDIS.del   "alice.http|paths:#{application.name}"
      unless values.empty?
        REDIS.hmset "alice.http|paths:#{application.name}", *values
      end
    end
  end

private

  def send_to_redis
    self.class.send_to_redis_for_application(self.application)
  end

end
