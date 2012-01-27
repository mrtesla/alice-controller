class Pluto::ProcessDefinition < ActiveRecord::Base

  validates :owner_id,
    presence: true
  validates :owner_type,
    presence: true

  validates :name,
    presence:   true,
    uniqueness: { scope: [:owner_type, :owner_id] }

  validates :concurrency,
    presence: true

  validates :command,
    presence: true,
    if:       lambda { |r| r.owner_type == 'Core::Release' }

  belongs_to :owner, polymorphic: true

  default_scope order(:name)

  def ui_name
    name
  end

end
