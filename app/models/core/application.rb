class Core::Application < ActiveRecord::Base

  validates :name,
    presence:   true,
    uniqueness: true

  has_many :http_backends,
    class_name:  'Http::Backend',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  has_many :http_path_rules,
    class_name:  'Http::PathRule',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  has_many :http_domain_rules,
    class_name:  'Http::DomainRule',
    foreign_key: 'core_application_id',
    dependent:   :destroy

  default_scope order(:name)

end
