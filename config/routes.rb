Alice::Application.routes.draw do

  root to: 'root#index'

  devise_for :users
  resources :users

  namespace :core do
    resources :machines
    resources :applications do
      delete 'cache', on: :member, action: 'bust_cache'

      resources :path_rules
      resources :domain_rules
    end
  end

  namespace :http do
    resources :domain_rules
    resources :path_rules
    resources :backends
    resources :passers
    resources :routers
  end

  scope path: '/core/applications/:application_id', as: 'core_application' do
    namespace :http do
      resources :domain_rules, only: [:new, :create]
      resources :path_rules,   only: [:new, :create]
    end
  end

  namespace :api_v1 do
    post 'register',              to: 'endpoints#register'
    post 'probe_report',          to: 'endpoints#probe_report'
    get  'endpoints',             to: 'endpoints#index'
    get  'routers',               to: 'endpoints#routers'
    put  'register_static_paths', to: 'applications#register_static_paths'
  end

  mount FnordMetric.embedded, at: '/stats'

end
