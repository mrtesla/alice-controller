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
    class_name:  'Core::Machine'

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

private

  def set_next_number
    self.number = (self.class.where(core_application_id: core_application_id).maximum(:number) || 0) + 1
  end

end
