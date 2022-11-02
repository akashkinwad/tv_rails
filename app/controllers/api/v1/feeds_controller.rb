module Api
  module V1
    class FeedsController < ApiController
      def index
        @posts = Post.all.includes(:likes, :comments).order(created_at: :desc)
      end
    end
  end
end
