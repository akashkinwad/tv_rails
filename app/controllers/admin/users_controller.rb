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

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      format.js
      format.json {
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors.first, status: :unprocessable_entity
        end
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :first_name,
      :last_name,
      :daily_news,
      :nft_account,
      :wallet_address,
      :nft_details
    )
  end
end
