class Pluto::ProcessInstance < ActiveRecord::Base

  # How ProcessInstances are managed:
  #
  # 1.  Capistrano deploys a new release and registers the processes and machines associated with the release.
  # 2.  Alice analyses the environment and process definitions and builds a list of process instances.
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

  def as_json(*)
    definition  = self.pluto_process_definition
    release     = definition.owner
    application = release.core_application
    machine     = self.core_machine
    environment = application.resolved_pluto_environment_variables(release)
    environment = environment.index_by(&:name)

    task    = [application.name, release.number, definition.name, self.instance].join(':')
    command = definition.command

    ports = command.scan(/[$](?:[A-Z0-9_]+_)?PORT\b/).map do |match|
      name = match[1..-1]
      type = name.sub(/_PORT$/, '').downcase
      port = nil

      if type == 'port' or type == ''
        type = 'http'
      end

      if environment.key?(name)
        port = environment[name].value.to_i
        environment.delete(name)
      end

      { "name" => name, "type" => type }.tap do |p|
        p["port"] = port if port
      end
    end

    env = environment.values.map do |var|
      { "name" => var.name, "value" => var.value }
    end

    env.concat [
      { "name" => "ALICE_PROCESS",  "value" => definition.name },
      { "name" => "ALICE_INSTANCE", "value" => self.instance   },
      { "name" => "ALICE_MACHINE",  "value" => machine.host    }
    ]

    {
      "task"    => task,
      "command" => command,
      "ports"   => ports,
      "env"     => env
    }.tap do |task|
      task["etag"] = Digest::SHA1.hexdigest(task.inspect)
    end
  end

end
