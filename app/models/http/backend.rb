class Http::Backend < ActiveRecord::Base

  validates :core_machine_id,
    presence:   true

  validates :core_application_id,
    presence:   true

  validates :process,
    presence:   true

  validates :instance,
    presence:   true,
    uniqueness: { scope: :core_application_id }

  validates :port,
    presence:   true,
    uniqueness: { scope: :core_machine_id }

  belongs_to :core_machine,
    class_name:  'Core::Machine',
    foreign_key: 'core_machine_id'
  belongs_to :core_application,
    class_name:  'Core::Application',
    foreign_key: 'core_application_id'

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    by_lookup_key = {}

    all.each do |backend|
      lookup_key = [backend.core_application.name, backend.process].join(':')

      by_lookup_key[lookup_key] ||= []
      by_lookup_key[lookup_key].push [
        backend.core_machine.host,
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
