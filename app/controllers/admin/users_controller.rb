class Admin::UsersController < ApplicationController
  layout 'admin'

  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.includes(comments: :replies)
  end
end
