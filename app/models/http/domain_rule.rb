class Http::DomainRule < ActiveRecord::Base

  serialize :actions, JSON

  validates :core_application_id,
    presence: true

  validates :domain,
    presence:   true,
    uniqueness: true

  validates :actions,
    presence: true

  belongs_to :core_application,
    class_name:  'Core::Application',
    foreign_key: 'core_application_id'

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    values = []

    all.map do |rule|
      values.push rule.domain
      values.push JSON.dump([rule.id, rule.actions])
    end

    REDIS.multi do
      REDIS.del   "alice.http|domains"
      unless values.empty?
        REDIS.hmset "alice.http|domains", *values
      end
    end
  end

  def request_count(start, window)
    start  = start.to_i
    rem    = start % window
    start -= rem

    REDIS.hget("alice.stats|domains|reqs", "#{self.id}|#{start}|#{window}") || 0
  end

  def rpm(start, window)
    request_count(start, window).to_f / (window / 60)
  end

private

  def send_to_redis
    self.class.send_to_redis
  end

end
