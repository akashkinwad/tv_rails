Rails.application.routes.draw do
  root to: 'home#home'

  devise_for :users, path: 'admin'

  get "/home/*page" => "home#show"

  resources :users
  resources :posts
  resources :categories

  # API routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users,
                  controllers: {
                    sessions: 'api/v1/sessions',
                    registrations: 'api/v1/registrations',
                    passwords: 'api/v1/passwords'
                  },
                  path_names: {
                    sign_in: :login,
                    sign_out: :logout,
                    registration: :signup,
                    password: :forgot_password
                  }

      devise_scope :user do
        post 'users/verify_otp', to: 'registrations#verify_otp'
        post 'users/send_otp', to: 'registrations#send_otp'
        post 'users/resend_otp', to: 'registrations#resend_otp'
      end

      resources :users, only: [:show, :update] do
        member do
          get :profile, to: 'users#show'
          patch :update_profile, to: 'users#update'
          post :follow
          post :unfollow
        end
      end

      resources :posts do
        resources :comments
      end
      resources :feeds, only: :index
      resources :likes, only: [] do
        collection do
          post :like
          post :dislike
        end
      end
    end
  end
end
