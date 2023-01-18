class User::UsersController < ApplicationController
  layout 'user'

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def show
    if params[:page] == 'listings'
      @listing_offers = current_user.listing_offers
    elsif params[:page] == 'created'
      @nft_posts = current_user.nft_posts.state_created
    else
      @nft_posts = current_user.cliamed_posts
    end
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to user_user_path(current_user), notice: "Details was successfully updated." }
        format.json { render json: current_user, status: :created }
        format.js   { render :show, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :amount,
        :details,
        :nft_post_id
      )
    end
end
