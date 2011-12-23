class Http::Router < ActiveRecord::Base

  validates :core_machine_id,
    presence:   true

  validates :port,
    presence:   true,
    uniqueness: { scope: :core_machine_id }

  belongs_to :core_machine,
    class_name:  'Core::Machine',
    foreign_key: 'core_machine_id'

  default_scope order(:port)

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

  def error_level
    if down_since
      'important'
    elsif last_seen_at and last_seen_at < 1.minutes.ago
      'warning'
    else
      'success'
    end
  end

  def state_message
    if down_since
      "down since #{down_since.to_s(:short)}"
    elsif last_seen_at and last_seen_at < 1.minutes.ago
      "last seen at #{last_seen_at.to_s(:short)}"
    else
      "up"
    end
  end

private

  def send_to_redis
    self.class.send_to_redis
  end

end
