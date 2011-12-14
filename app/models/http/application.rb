class Http::Application < ActiveRecord::Base

  validates :name,
    presence:   true,
    uniqueness: true

  has_many :backends,
    dependent: :destroy

  has_many :path_rules,
    dependent: :destroy

end
