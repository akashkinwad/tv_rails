module Api
  module V1
    class PostsController < ApiController
      before_action :find_post, only: [:update]

      def index
        posts = current_user.posts.includes(:likes).order(created_at: :desc)
        render json: posts.map(&:to_json)
      end

      def create
        post = current_user.posts.new(post_params)
        if post.save
          if params[:post][:media]
            file = params[:post][:media]
            folder_path = "#{Rails.env}/#{current_user.id}/posts/#{post.id}/#{Time.now.to_i}-#{file.original_filename}"
            media_url = upload_to_s3(file, folder_path)
            post.update(
              url: media_url,
              content_type: file.content_type,
              extension: file.original_filename.split('.').last
            )
          end

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
          if params[:post][:media]
            file = params[:post][:media]
            folder_path = "#{Rails.env}/#{current_user.id}/posts/#{@post.id}/#{Time.now.to_i}-#{file.original_filename}"
            media_url = upload_to_s3(file, folder_path)
            @post.url = media_url
            @post.content_type = file.content_type
            @post.extension = file.original_filename.split('.').last
          end

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
