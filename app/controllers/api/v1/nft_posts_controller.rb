module Api
  module V1
    class NftPostsController < ApiController
      before_action :find_post, only: [:show]

      def index
        @nft_posts = NftPost.includes(:user).order(created_at: :desc)
      end

      def show; end

      private

      def find_post
        @nft_post = NftPost.find_by(id: params[:id])

        unless @nft_post.present?
          render json: { error: 'NFT Post not found' }, status: 404 and return
        end
      end
    end
  end
end
