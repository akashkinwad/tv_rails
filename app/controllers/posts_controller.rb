class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  private

  def authenticate_admin
    unless current_user.admin?
      redirect_to root_path, notice: 'You are not authorized to perform this action'
    end
  end
end
