class User::BidsController < ApplicationController
  layout 'user'

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def new
    @offer = Offer.find(params[:offer_id])
    @bid = current_user.bids.new(offer: @offer)
    @highest_bid_amount = @offer.bids.maximum(:amount) || 0

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @offer = current_user.bids.new(offer_params)
    respond_to do |format|
      if @offer.save
        format.html { redirect_to user_offer_url(@bid.offer_id), notice: "Bid was successfully created." }
        format.json { render json: @bid, status: :created }
        format.js   { render :new, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  private
    def offer_params
      params.require(:bid).permit(
        :amount,
        :details,
        :offer_id
      )
    end
end
