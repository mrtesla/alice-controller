class Core::Machine < ActiveRecord::Base

  validates :host,
    presence:   true,
    uniqueness: true

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

end
