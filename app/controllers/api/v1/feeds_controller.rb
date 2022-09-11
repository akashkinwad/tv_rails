module Api
  module V1
    class FeedsController < ApiController
      def index
        posts = Post.all.order(created_at: :desc)
        render json: posts
      end
    end
  end
end
