class Http::DomainRule < ActiveRecord::Base

  serialize :actions, JSON

  validates :domain,
    presence:   true,
    uniqueness: true

  validates :actions,
    presence: true

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    values = []

    all.map do |rule|
      values.push rule.domain
      values.push rule.actions_before_type_cast
    end

    REDIS.multi do
      REDIS.del   "alice.http|domains"
      unless values.empty?
        REDIS.hmset "alice.http|domains", *values
      end
    end
  end

private

  def send_to_redis
    self.class.send_to_redis
  end

end
