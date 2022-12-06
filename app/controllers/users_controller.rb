class UsersController < ApplicationController
  before_action :authenticate_user!

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
      :nft_account_id,
      :nft_details
    )
  end
end
