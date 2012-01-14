class Http::DomainRule < ActiveRecord::Base

  serialize :actions, JSONColumn.new([])

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

  default_scope order(:domain)

  after_save    :send_to_redis
  after_destroy :send_to_redis

  def ui_name
    domain
  end

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

private

  def send_to_redis
    self.class.send_to_redis
  end

end
