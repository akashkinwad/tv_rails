module Api
  module V1
    class FeedsController < ApiController
      def index
        @posts = Post.except_deleted
                  .page(params[:page]).per_page(10)
                  .includes(:likes, :comments)
                  .order(created_at: :desc)
      end
    end
  end
end
