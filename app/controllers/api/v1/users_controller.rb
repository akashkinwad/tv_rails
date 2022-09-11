module Api
  module V1
    class UsersController < ApiController

      def show
        render json: {
          messages: nil,
          is_success: true,
          data: { user: current_user }
        }, status: :ok
      end

      def update
        if current_user.update(user_params)
          render json: {
            messages: 'User updated successfully',
            is_success: true,
            data: { user: current_user }
          }, status: :ok
        else
          render json: {
            messages: current_user.errors.full_messages.first,
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :first_name,
          :last_name,
          :daily_news,
          :image_url,
          :video_url,
        )
      end
    end
  end
end
