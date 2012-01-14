class Pluto::EnvironmentVariable < ActiveRecord::Base

  validates :owner_id,
    presence: true
  validates :owner_type,
    presence: true

  validates :name,
    presence:   true,
    uniqueness: { scope: [:owner_type, :owner_id] }

  validates :value,
    presence: true

  belongs_to :owner, polymorphic: true

  default_scope order(:name)

  def ui_name
    name
  end

end
