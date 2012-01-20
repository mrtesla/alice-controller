class Http::PathRule < ActiveRecord::Base

  serialize :actions, JSONColumn.new([])

  validates :owner_id,
    presence: true
  validates :owner_type,
    presence: true

  validates :path,
    presence:   true,
    uniqueness: { scope: [:owner_type, :owner_id] }

  validates :actions,
    presence: true

  belongs_to :owner, polymorphic: true

  default_scope order(:path)

  def ui_name
    path
  end

  def send_to_redis
    owner = self.owner
    if Core::Application === owner
      self.class.send_to_redis_for_application(owner)
    end
  end

  def self.send_to_redis_for_application(application)
    values = []

    application.resolved_http_path_rules.each do |rule|
      values.push rule.path
      values.push JSON.dump([rule.id, rule.actions])
    end

    REDIS.multi do
      REDIS.del   "alice.http|paths:#{application.name}"
      unless values.empty?
        REDIS.hmset "alice.http|paths:#{application.name}", *values
      end
    end
  end

end
