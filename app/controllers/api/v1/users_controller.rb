module Api
  module V1
    class UsersController < ApiController

      def show;end

      def update
        upload_and_set_attr(:blr_image, params[:user][:blr_image], 'blur-image')
        upload_and_set_attr(:image_url, params[:user][:image], 'profile-image')
        upload_and_set_attr(:video_url, params[:user][:video], 'profile-video')

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
            messages: 'You have followed user successfully',
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
            messages: 'Successfully unfollowed a user',
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

      def followers
        @user = User.find_by(id: params[:id])
        if @user
          @followers = @user.followers
        else
          render json: {
            messages: 'User not found',
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      def following
        @user = User.find_by(id: params[:id])
        if @user
          @followings = @user.followees
        else
          render json: {
            messages: 'User not found',
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      def details
        @user = User.find_by(id: params[:id])
        if @user
          @is_following = current_user.followees.include?(@user)
          @posts = @user.posts if @is_following
        else
          render json: {
            messages: 'User not found',
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

      def upload_and_set_attr(attribute, file, attr_type)
        if file
          extension = File.extname(file)
          folder_path = "#{Rails.env}/#{current_user.id}/profiles/#{current_user.id}-#{Time.now.to_i}-#{attr_type}#{extension}"
          upload_object = upload_to_s3(file, folder_path)
          current_user.send("#{attribute}=", upload_object.public_url) if upload_object
        end
      end
    end
  end
end
