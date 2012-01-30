class Pluto::ProcessInstance < ActiveRecord::Base

  # How ProcessInstances are managed:
  #
  # 1.  Capistrano deploys a new release and registers the processes and machines associated with the release.
  # 2.  Alice analyses the environment and process defintions and builds a list of process instances.
  #      The instances are (currently) evenly distributed across all machines which have the new releases.
  # 3.  Capistrano activates the new releases.
  # 4.  Alice pings a the associated machines (including the machines of the deactivated release).
  # 5.  The associated machines pull a new list of process instances.
  # 6.  The machines stop and remove the services which have no instance counterpart.
  # 7.  The associated machines build and start new pluto services for all the new instances.
  # 8.  For each stopped service Alice is notified.
  # 9.  For each removed service Alice is notified.
  # 10. For each installed service Alice is notified.
  # 11. For each started service Alices is notified.

  validates :pluto_process_definition_id,
    presence: true

  validates :core_machine_id,
    presence: true

  validates :instance,
    presence:     true,
    uniqueness: { scope: 'pluto_process_definition_id' },
    numericality: {
      greater_than: 0,
      only_integer: true
    }

  belongs_to :core_machine,
    class_name:  'Core::Machine',
    foreign_key: 'core_machine_id'

  belongs_to :pluto_process_definition,
    class_name:  'Pluto::ProcessDefinition',
    foreign_key: 'pluto_process_definition_id'

  def ui_name
    "#{self.pluto_process_definition.name}:#{self.instance}"
  end

  def state
    if self.running_since
      'up'
    else
      'down'
    end
  end

end
