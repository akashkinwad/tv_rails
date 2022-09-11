module Api
  module V1
    class PostsController < ApiController
      before_action :find_post, only: [:update]

      def index
        posts = current_user.posts.order(created_at: :desc)
        render json: posts
      end

      def create
        post = current_user.posts.new(post_params)
        if post.save
          render json: {
            messages: 'Post created successfully',
            is_success: true,
            data: { post: post }
          }, status: :ok
        else
          render json: {
            messages: post.errors.full_messages.first,
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          render json: {
            messages: 'Post created successfully',
            is_success: true,
            data: { post: @post }
          }, status: :ok
        else
          render json: {
            messages: @post.errors.full_messages.first,
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:post).permit(
          :title,
          :description,
          :category,
          :hastag
        )
      end

      def find_post
        @post = current_user.posts.find_by(id: params[:id])

        unless @post.present?
          render json: { error: 'Post not found' }, status: 404 and return
        end
      end
    end
  end
end
