class Http::Backend < ActiveRecord::Base

  validates :machine_id,
    presence:   true

  validates :application_id,
    presence:   true

  validates :process,
    presence:   true

  validates :port,
    presence:   true,
    uniqueness: { scope: :machine_id }

  belongs_to :machine
  belongs_to :application

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    by_lookup_key = {}

    all.each do |backend|
      lookup_key = [backend.application.name, backend.process].join(':')

      by_lookup_key[lookup_key] ||= []
      by_lookup_key[lookup_key].push [
        backend.machine.host,
        backend.port
      ].join(' ')
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

private

  def send_to_redis
    self.class.send_to_redis
  end

end
