class Http::Machine < ActiveRecord::Base

  validates :host,
    presence:   true,
    uniqueness: true

  has_many :routers,
    dependent: :destroy

  has_many :passers,
    dependent: :destroy

  has_many :backends,
    dependent: :destroy

end
