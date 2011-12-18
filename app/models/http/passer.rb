class Http::Passer < ActiveRecord::Base

  validates :core_machine_id,
    presence:   true

  validates :port,
    presence:   true,
    uniqueness: { scope: :core_machine_id }

  belongs_to :core_machine

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def self.send_to_redis
    Core::Machine.all.each do |machine|
      send_to_redis_for_machine(machine)
    end
  end

  def self.send_to_redis_for_machine(machine)
    values = machine.http_passers.map do |passer|
      passer.port.to_s
    end

    REDIS.multi do
      REDIS.del   "alice.http|passers:#{machine.host}"
      values.each do |value|
        REDIS.lpush "alice.http|passers:#{machine.host}", value
      end
    end
  end

private

  def send_to_redis
    self.class.send_to_redis_for_machine(core_machine)
  end

end
