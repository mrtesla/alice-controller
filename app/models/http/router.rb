class Http::Router < ActiveRecord::Base

  validates :core_machine_id,
    presence:   true

  validates :port,
    presence:   true,
    uniqueness: { scope: :core_machine_id }

  belongs_to :core_machine

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    values = all.map do |router|
      [router.core_machine.host, router.port].join(' ')
    end

    REDIS.multi do
      REDIS.del   "alice.http|routers"
      values.each do |value|
        REDIS.lpush "alice.http|routers", value
      end
    end
  end

private

  def send_to_redis
    self.class.send_to_redis
  end

end
