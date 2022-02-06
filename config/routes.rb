Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      post '/auth', to: 'auth#create'
      delete '/auth', to: 'auth#delete'
      post '/auth/register', to: 'auth#register'

      get '/user/me', to: 'user#me'
      get '/user/tweets', to: 'user#tweets'
      get '/user/likes', to: 'user#likes'

      resources :tweet, only: %i[index show create update destroy] do
        put :like, on: :member
      end
    end
  end
end
