module Api
  module V1
    class RegistrationsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token
      before_action :ensure_mobile_params_exist

      def create
        user = User.find_by(mobile: params[:user].dig(:mobile))
        if user
          if user.verified?
            if user.update(user_params)
              user.update(verified: true)

              render json: {
                messages: 'Sign Up Successfully',
                is_success: true,
                data: { user: user }
              }, status: :ok
            else
              render json: {
                messages: 'Sign Up Failed',
                is_success: false,
                data: user.errors.full_messages.first
              }, status: :unprocessable_entity
            end
          else
            render json: {
              messages: 'Mobile is not verified',
              is_success: false,
              data: {}
            }, status: :unprocessable_entity
          end
        else
          render json: {
            messages: 'Mobile is not verified',
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      def send_otp
        user = User.find_or_initialize_by(mobile: params[:user].dig(:mobile))
        if user.persisted?
          render json: {
            messages: 'Mobile already registered',
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        else
          user.generate_user_otp!

          render json: {
            messages: 'OTP Sent Successfully',
            is_success: true,
            data: { user: user }
          }, status: :ok
        end
      end

      def verify_otp
        user = User.find_by(mobile: params[:user].dig(:mobile))
        if user
          if user.otp_valid?
            if params[:user].dig(:otp) == user.mobile_otp
              user.verified = true
              user.save(validate: false)

              render json: {
                messages: 'OTP Verified Successfully',
                is_success: true,
                data: { user: user }
              }, status: :ok
            else
              render json: {
                messages: 'Invalid OTP, please enter correct otp details',
                is_success: false,
                data: {}
              }, status: :unprocessable_entity
            end
          else
            render json: {
              messages: 'OTP is expired, please generate new otp',
              is_success: false,
              data: {}
            }, status: :unprocessable_entity
          end
        else
          render json: {
            messages: 'Wrong Mobile Number',
            is_success: true,
            data: { user: user }
          }, status: :ok
        end
      end

      private

      def ensure_mobile_params_exist
        return if params[:user].dig(:mobile)

        render json: {
          messages: 'Missing Mobile',
          is_success: false,
          data: {}
        }, status: :bad_request
      end

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :username
        )
      end

      def mobile_params
        params.require(:user).permit(:mobile)
      end
    end
  end
end
