Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      post '/auth', to: 'auth#create'
      delete '/auth', to: 'auth#delete'
      post '/auth/register', to: 'auth#register'

      resources :tweet, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
