class Http::Backend < ActiveRecord::Base

  validates :core_machine_id,
    presence:   true

  validates :core_application_id,
    presence:   true

  validates :process,
    presence:   true

  validates :instance,
    presence:   true,
    uniqueness: { scope: [:core_application_id, :process] }

  validates :port,
    presence:   true

  belongs_to :core_machine,
    class_name:  'Core::Machine',
    foreign_key: 'core_machine_id'
  belongs_to :core_application,
    class_name:  'Core::Application',
    foreign_key: 'core_application_id'

  after_save  :reclaim_port
  before_save :cache_ui_name

  def self.send_to_redis
    by_lookup_key = {}

    where(down_since: nil).includes(:core_application, :core_machine).each do |backend|
      lookup_key = [backend.core_application.name, backend.process].join(':')

      by_lookup_key[lookup_key] ||= []
      by_lookup_key[lookup_key].push JSON.dump([
        backend.id,
        backend.core_machine.host,
        backend.port,
        backend.instance
      ])
    end

    REDIS.multi do
      by_lookup_key.each do |key, values|
        REDIS.del   "alice.http|backends:#{key}"
        values.each do |value|
          REDIS.lpush "alice.http|backends:#{key}", value
        end
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

    key = "fnordmetric-alice-gauge-instance_requests_per_day-#{window}-#{start}"
    REDIS.zscore(key, "#{self.core_application.name}|#{self.process}:#{self.instance}") || 0
  end

  def rpm(start, window)
    request_count(start, window).to_f / (window / (24 * 60))
  end

private

  def cache_ui_name
    self.ui_name = "#{self.core_application.name}:#{self.process}:#{self.instance}"
  end

end
