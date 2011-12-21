Alice::Application.routes.draw do
  namespace :http do
    resources :domain_rules
    resources :path_rules
    resources :backends
    resources :passers
    resources :routers
  end

  namespace :core do
    resources :machines
    resources :applications
  end

  namespace :api_v1 do
    match 'register', to: 'endpoints#register'
  end
end
