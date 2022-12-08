Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root to: 'home#home'

  namespace :admin do
    resources :users
    resources :posts
    resources :categories
  end

  namespace :user do
    resources :nft_posts do
      collection do
        get :explore
        get :mobile_nft
      end
    end
  end
  resources :users, only: [:update]

  get "/home/*page" => "home#show"

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
          get :followers
          get :following
          get :details
          get :posts
        end
      end

      resources :posts do
        resources :comments
      end
      resources :feeds, only: :index
      resources :nft_posts, only: [:index, :show]
      resources :nfts, only: [] do
        collection do
          post :sign_nft
        end
      end
      resources :likes, only: [] do
        collection do
          post :like
          post :dislike
        end
      end
    end
  end
end
