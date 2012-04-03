class Pluto::ProcessDefinition < ActiveRecord::Base

  attr_accessor :parent
  after_save    :repopulate_process_instances
  after_destroy :repopulate_process_instances

  validates :owner_id,
    presence: true
  validates :owner_type,
    presence: true

  validates :name,
    presence:   true,
    uniqueness: { scope: [:owner_type, :owner_id] }

  validates :concurrency,
    presence: true,
    numericality: {
      greater_than_or_equal_to:  0,
      less_than_or_equal_to:    10,
      only_integer: true
    }

  validates :command,
    presence: true,
    if:       lambda { |r| r.owner_type == 'Core::Release' }

  belongs_to :owner, polymorphic: true

  has_many :pluto_process_instances,
    class_name:  'Pluto::ProcessInstance',
    foreign_key: 'pluto_process_definition_id',
    dependent:   :destroy

  default_scope order(:name)

  def ui_name
    name
  end

private

  def repopulate_process_instances
    if 'Core::Application' === self.owner_type
      self.owner.active_core_release.try(:populate_process_instances)
    end
  end

end
