module Api
  module V1
    class FeedsController < ApiController
      def index
        posts = Post.all.includes(:likes, :comments).order(created_at: :desc)
        render json: posts.map(&:render_json)
      end
    end
  end
end
