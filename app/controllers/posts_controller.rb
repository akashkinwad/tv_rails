class PostsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @posts = Post.includes(:user)
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  private

  def authenticate_admin
    unless current_user.admin?
      sign_out(current_user)
      redirect_to new_user_session_path, notice: 'You are not authorized to perform this action'
    end
  end
end
