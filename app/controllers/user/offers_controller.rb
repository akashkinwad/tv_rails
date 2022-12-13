class User::OffersController < ApplicationController
  layout 'user'

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def new
    @offer = current_user.offers.new
    @nft_post_id = params[:nft_post_id]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @offer = current_user.offers.new(offer_params)
    respond_to do |format|
      if @offer.save
        format.html { redirect_to user_nft_post_url(@offer.nft_post_id), notice: "Offer was successfully created." }
        format.json { render json: @offer, status: :created }
        format.js   { render :new, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  private
    def offer_params
      params.require(:offer).permit(
        :amount,
        :details,
        :nft_post_id
      )
    end
end
