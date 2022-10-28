class Admin::PostsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @posts = Post.includes(:user)
  end

  def show
    @post = Post.find_by(id: params[:id])
  end
end
