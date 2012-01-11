class Core::Release < ActiveRecord::Base

  validates :core_application_id,
    presence: true

  validates :number,
    presence:   true,
    uniqueness: true

  belongs_to :core_application,
    class_name:  'Core::Application',
    foreign_key: 'core_application_id'

  default_scope order(:number)

  def ui_name
    "##{number}"
  end

end
