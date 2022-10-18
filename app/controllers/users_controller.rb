class UsersController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.includes(comments: :replies)
  end

  private

  def authenticate_admin
    unless current_user.admin?
      redirect_to root_path, notice: 'You are not authorized to perform this action'
    end
  end
end
