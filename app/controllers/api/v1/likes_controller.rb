module Api
  module V1
    class LikesController < ApiController
      before_action :set_likeable

      def like
        like = current_user.likes.new(like_params)

        if like.save
          render json: {
            messages: 'Like created successfully',
            is_success: true,
            data: { like: like }
          }, status: :ok
        else
          render json: {
            messages: like.errors.full_messages.first,
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      def dislike
        like = current_user.likes.find_by(likeable: @likeable)

        if like && like.destroy
          render json: {
            messages: 'Disliked post',
            is_success: true,
            data: {}
          }, status: :ok
        else
          render json: {
            messages: like ? like.errors.full_messages.first : 'You have not liked a post',
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      private

      def like_params
        params.require(:like).permit(:value, :likeable_id, :likeable_type)
      end

      def set_likeable
        @likeable =
          case params.dig(:like, :likeable_type)
          when 'Post'
            Post.find(params.dig(:like, :likeable_id))
          end

        unless @likeable
          render json: {
            messages: 'Post does not exists',
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
