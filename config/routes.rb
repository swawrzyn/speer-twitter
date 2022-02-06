Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/auth', to: 'auth#create'
      post '/auth/register', to: 'auth#register'
      delete '/auth', to: 'auth#delete'
    end
  end
end
