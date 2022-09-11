Rails.application.routes.draw do
  root to: 'demos#index'

  devise_for :users

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
      end

      resources :users, only: [:show, :update] do
        member do
          get :profile, to: 'users#show'
          patch :update_profile, to: 'users#update'
        end
      end

      resources :posts do
        resources :comments
      end
      resources :feeds, only: :index
    end
  end
end
