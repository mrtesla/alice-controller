class Core::Release < ActiveRecord::Base

  validates :core_application_id,
    presence: true

  validates :number,
    presence:   true,
    uniqueness: { scope: :core_application_id }

  belongs_to :core_application,
    class_name:  'Core::Application',
    foreign_key: 'core_application_id'

  has_one :actived_core_application,
    class_name:  'Core::Application',
    foreign_key: 'active_core_release_id',
    dependent:   :nullify

  has_and_belongs_to_many :core_machines,
    class_name:              'Core::Machine',
    join_table:              'core_machines_core_releases',
    foreign_key:             'core_release_id',
    association_foreign_key: 'core_machine_id'

  has_many :http_path_rules,
    class_name:  'Http::PathRule',
    dependent:   :destroy,
    as:          :owner

  has_many :pluto_environment_variables,
    class_name:  'Pluto::EnvironmentVariable',
    dependent:   :destroy,
    as:          :owner

  has_many :pluto_process_definitions,
    class_name:  'Pluto::ProcessDefinition',
    dependent:   :destroy,
    as:          :owner

  default_scope order('number DESC')

  before_validation :set_next_number, :on => :create

  def ui_name
    "##{number}"
  end

  def activate!
    application = self.core_application
    application.active_core_release = self
    application.save!

    # update chef server
    update_chef!
  end

  def update_chef!
    # Alice::Chef::ProcessUpdater.new(self).update
  end

  def populate_process_instances
    definitions = self.core_application.resolved_pluto_process_definitions(self)
    machines    = self.core_machines.all
    instances   = Pluto::ProcessInstance.where(:pluto_process_definition_id => definitions.map(&:id)).all
    instances   = instances.index_by(&:ui_name)

    definitions.each do |definition|
      (1..definition.concurrency).each do |instance|
        machine = machines.shift
        machines.push machine

        instance = definition.pluto_process_instances.build(
          core_machine:  machine,
          instance:      instance,
          running_since: nil,
          down_since:    Time.at(0),
          last_seen_at:  nil)

        instance.save
        instances.delete instance.ui_name
      end
    end

    instances.values.map(&:destroy)
  end

private

  def set_next_number
    self.number = (self.class.where(core_application_id: core_application_id).maximum(:number) || 0) + 1
  end

end
