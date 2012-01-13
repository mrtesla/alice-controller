Alice::Application.routes.draw do

  namespace :core do resources :releases end

  root to: 'root#index'

  devise_for :users
  resources :users

  namespace :core do
    resources :machines
    resources :applications do
      delete 'cache', on: :member, action: 'bust_cache'
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

    post 'releases',
      to: 'releases#create'

    post 'releases/:id/activate',
      to: 'releases#activate'

    post 'applications/:application_name/maintenance',
      to: 'applications#maintenance_mode_on',
      constraints: { application_name: /.*/ }

    delete 'applications/:application_name/maintenance',
      to: 'applications#maintenance_mode_off',
      constraints: { application_name: /.*/ }

  end

  mount FnordMetric.embedded, at: '/stats'

end
