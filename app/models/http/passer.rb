class Http::Passer < ActiveRecord::Base

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
    Core::Machine.all.each do |machine|
      send_to_redis_for_machine(machine)
    end
  end

  def self.send_to_redis_for_machine(machine)
    values = machine.http_passers.where(down_since: nil).map do |passer|
      JSON.dump([passer.id, passer.port])
    end

    REDIS.multi do
      REDIS.del   "alice.http|passers:#{machine.host}"
      values.each do |value|
        REDIS.lpush "alice.http|passers:#{machine.host}", value
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
    self.class.send_to_redis_for_machine(core_machine)
  end

  def reclaim_port
    self.core_machine.claim_port_for(self)
  end

  def request_count(start, window)
    start  = start.to_i
    rem    = start % window
    start -= rem

    key = "fnordmetric-alice-gauge-passer_requests_per_day-#{window}-#{start}"
    REDIS.zscore(key, "#{self.core_machine.host}:#{self.port}") || 0
  end

  def rpm(start, window)
    request_count(start, window).to_f / (window / 60)
  end

end
