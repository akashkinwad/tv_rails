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

      def follow
        @user = User.find(params[:id])
        current_user.followees << @user
        redirect_back(fallback_location: user_path(@user))
      end

      def unfollow
        @user = User.find(params[:id])
        current_user.followed_users.find_by(followee_id: @user.id).destroy
        redirect_back(fallback_location: user_path(@user))
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
