module Api
  module V1
    class PostsController < ApiController
      before_action :find_post, only: [:update]

      def index
        posts = current_user.posts.order(created_at: :desc)
        render json: posts.map(&:render_json)
      end

      def create
        post = current_user.posts.new(post_params)

        if params[:post][:media]
          file = params[:post][:media]
          folder_path = "#{Rails.env}/posts/#{current_user.id}/#{Time.now.to_i}-#{file.original_filename}"
          media_url = upload_to_s3(open(file).read, folder_path)
          post.url = media_url
        end

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
        if params[:post][:media]
          file = params[:post][:media]
          folder_path = "#{Rails.env}/posts/#{current_user.id}/#{Time.now.to_i}-#{file.original_filename}"
          media_url = upload_to_s3(open(file).read, folder_path)
          @post.url = media_url
        end

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
          :hastag,
          :content_type,
          :extension
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
