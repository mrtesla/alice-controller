class Core::Machine < ActiveRecord::Base

  validates :host,
    presence:   true,
    uniqueness: true

  has_many :http_routers,
    dependent: :destroy

  has_many :http_passers,
    dependent: :destroy

  has_many :http_backends,
    dependent: :destroy

  def name
    host
  end

end
