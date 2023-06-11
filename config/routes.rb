Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :webhooks do
    resource :movies, only: [:create]
    resource :stripe, controller: :stripe, only: [:create]
  end
end
