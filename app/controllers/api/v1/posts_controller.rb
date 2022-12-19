module Api
  module V1
    class PostsController < ApiController
      before_action :find_post, only: [:update]

      def index
        posts = current_user.posts.except_deleted
                  .page(params[:page]).per_page(10)
                  .includes(:likes).order(created_at: :desc)

        render json: { posts: posts.map(&:to_json), meta: paginate(posts) }
      end

      def create
        post = current_user.posts.new(post_params)
        if post.save
          upload_and_set_attr(post, :blr_image, params[:post][:blr_image], 'blr')
          upload_and_set_attr(post, :url, params[:post][:media], 'act')

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
            messages: 'Post updated successfully',
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

      def delete
        posts = current_user.posts.where(id: params[:ids])
        if posts.present?
          posts.update_all(status: 'deleted')

          render json: {
            messages: 'Post/Posts deleted successfully',
            is_success: true,
            data: {}
          }, status: :ok
        else
          render json: {
            messages: 'Failed to delete post/posts',
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
          :hashtag
        )
      end

      def find_post
        @post = current_user.posts.find_by(id: params[:id])

        unless @post.present?
          render json: { error: 'Post not found' }, status: 404 and return
        end
      end

      def upload_and_set_attr(post, attribute, file, attr_type)
        if file
          extension = File.extname(file)
          folder_path = "#{Rails.env}/#{current_user.id}/posts/#{post.id}-#{Time.now.to_i}-#{attr_type}#{extension}"
          upload_object = upload_to_s3(file, folder_path)

          if attribute == :url
            post.update(
              url: upload_object.public_url,
              content_type: file.content_type,
              extension: extension
            )
          else
            post.update(blr_image: upload_object.public_url)
          end if upload_object
        end
      end
    end
  end
end
