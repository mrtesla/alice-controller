Alice::Application.routes.draw do
  namespace :core do resources :machines end

  namespace :core do
    resources :machines
    resources :applications
  end

  match '_ping/router', to: 'ping#router'
  match '_ping/passer', to: 'ping#passer'
end
