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

  after_save :reclaim_port

  def self.send_to_redis
    values = self.where(down_since: nil).includes(:core_machine).map do |router|
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

  def send_to_redis
    self.class.send_to_redis
  end

  def reclaim_port
    self.core_machine.claim_port_for(self)
  end

  def request_count(start, window)
    start  = start.to_i
    rem    = start % window
    start -= rem

    key = "fnordmetric-alice-gauge-router_requests_per_hour-#{window}-#{start}"
    REDIS.zscore(key, "#{self.core_machine.host}:#{self.port}") || 0
  end

  def rpm(start, window)
    request_count(start, window).to_f / (window / 60)
  end

end
