module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token
      before_action :ensure_params_exist

      def create
        user = User.find_by(
          email: params[:user][:email]
        )
        return invalid_login_attempt unless user

        if user.valid_password?(params[:user][:password])
          sign_in(:user, user)
          render json: {
            success: true,
            message: "Signed in successfully",
            data: { token: user.generate_jwt }
          }, status: :ok
        else
          invalid_login_attempt
        end
      end

      private

      def ensure_params_exist
        return unless params[:user].blank?

        render json: {
          success: false,
          message: "missing user parameter"
        }, status: 422
      end

      def invalid_login_attempt
        warden.custom_failure!
        render json: {
          success: false,
          message: "Error with your email or password"
        }, status: 401
      end
    end
  end
end
