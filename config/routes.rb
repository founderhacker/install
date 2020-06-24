InstallRails::Application.routes.draw do
  resources :install_steps, path: 'steps'

  controller :main do
    get :test
    get :congratulations
  end

  root to: 'install_steps#index'
end
