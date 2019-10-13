Rails.application.routes.draw do
  get 'asignaturas_importantes/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :peso_asignaturas, format: :json
  end
end
