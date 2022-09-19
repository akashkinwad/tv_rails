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

        if current_user.followees << @user
          render json: {
            messages: 'You have followed successfully',
            is_success: true,
            data: {}
          }, status: :ok
        else
          render json: {
            messages: current_user.errors.full_messages.first,
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      def unfollow
        @user = User.find(params[:id])
        followed_user = current_user.followed_users.find_by(followee_id: @user.id)

        if followed_user && followed_user.destroy
          render json: {
            messages: 'Successfully unfollowed',
            is_success: true,
            data: {}
          }, status: :ok
        else
          render json: {
            messages: followed_user.present? ? current_user.errors.full_messages.first : 'User not found',
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
