Alice::Application.routes.draw do

  root to: 'root#index'

  devise_for :users
  resources :users

  namespace :core do
    resources :machines
    resources :applications do
      delete 'cache', on: :member, action: 'bust_cache'
    end
    resources :releases
  end

  namespace :http do
    resources :backends
    resources :passers
    resources :routers
  end

  scope path: '/core/applications/:application_id', as: 'core_application' do
    namespace :http do
      resources :domain_rules
      resources :path_rules
    end

    namespace :pluto do
      resources :environment_variables
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

    delete 'releases/:id',
      to: 'releases#destroy'

    post 'releases/:id/activate',
      to: 'releases#activate'

    post 'applications/:application_name/maintenance',
      to: 'applications#maintenance_mode_on',
      constraints: { application_name: /.*/ }

    delete 'applications/:application_name/maintenance',
      to: 'applications#maintenance_mode_off',
      constraints: { application_name: /.*/ }

    delete 'applications/:application_name/cache',
      to: 'applications#bust_cache',
      constraints: { application_name: /.*/ }

    get 'machines/:machine_host/routers',
      to: 'machines#routers',
      constraints: { machine_host: /.*/ }

    get 'machines/:machine_host/endpoints',
      to: 'machines#endpoints',
      constraints: { machine_host: /.*/ }

    post 'machines/:machine_host/probe_report',
      to: 'machines#probe_report',
      constraints: { machine_host: /.*/ }

  end

  mount FnordMetric.embedded, at: '/stats'

end
