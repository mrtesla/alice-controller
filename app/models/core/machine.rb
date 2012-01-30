class Core::Machine < ActiveRecord::Base

  validates :host,
    presence:   true,
    uniqueness: true

  has_and_belongs_to_many :core_releases,
    class_name:  'Core::Release'

  has_many :http_routers,
    class_name:  'Http::Router',
    foreign_key: 'core_machine_id',
    dependent:   :destroy

  has_many :http_passers,
    class_name:  'Http::Passer',
    foreign_key: 'core_machine_id',
    dependent:   :destroy

  has_many :http_backends,
    class_name:  'Http::Backend',
    foreign_key: 'core_machine_id',
    dependent:   :destroy

  def claim_port_for(endpoint)
    routers  = http_routers.where(port: endpoint.port)
    passers  = http_passers.where(port: endpoint.port)
    backends = http_backends.where(port: endpoint.port)

    if Http::Router === endpoint
      routers = routers.where("id != ?", endpoint.id)
    end
    if Http::Passer === endpoint
      passers = passers.where("id != ?", endpoint.id)
    end
    if Http::Backend === endpoint
      backends = backends.where("id != ?", endpoint.id)
    end

    routers.destroy_all
    passers.destroy_all
    backends.destroy_all
  end

end
