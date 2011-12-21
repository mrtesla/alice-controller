Alice::Application.routes.draw do
  namespace :http do resources :domain_rules end

  namespace :http do resources :path_rules end

  namespace :http do resources :backends end

  namespace :http do resources :passers end

  namespace :http do resources :routers end

  namespace :core do resources :applications end

  namespace :core do resources :machines end

  namespace :core do
    resources :machines
    resources :applications
  end

  match '_ping/router', to: 'ping#router'
  match '_ping/passer', to: 'ping#passer'
end
