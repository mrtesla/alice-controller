ActiveAdmin.register Http::PathRule do
  menu parent: 'Http'
  belongs_to :application
end
