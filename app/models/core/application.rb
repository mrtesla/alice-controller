class Core::Application < ActiveRecord::Base

  validates :name,
    presence:   true,
    uniqueness: true

  has_many :http_backends,
    class_name: 'Http::Backend',
    dependent:  :destroy

  has_many :http_path_rules,
    dependent: :destroy

end
