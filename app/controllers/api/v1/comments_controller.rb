module Api
  module V1
    class CommentsController < ApiController
      before_action :find_post

      def index
        @comments = @post.parent_comments.page(params[:page]).per_page(10).includes(:user, replies: [:replies, :user])
      end

      def create
        @comment = @post.comments.new(comment_params)
        @comment.user = current_user
        if @comment.save
          render json: {
            messages: 'Comment created successfully',
            is_success: true,
            data: { comment: @comment }
          }, status: :ok
        else
          render json: {
            messages: @comment.errors.full_messages.first,
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.require(:comment).permit(
          :body,
          :parent_id,
          :user_id
        )
      end

      def find_post
        @post = Post.find_by(id: params[:post_id])

        unless @post.present?
          render json: { error: 'Post not found' }, status: 404 and return
        end
      end
    end
  end
end
