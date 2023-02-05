class User::OffersController < ApplicationController
  layout 'user'

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def new
    @nft_post = NftPost.find(params[:nft_post_id])
    @offer = current_user.offers.new
    @highest_offer_amount = @nft_post.offers.maximum(:amount) || 0

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

  def explore
    @offers = Offer.state_created.includes(:user, :likes)
  end

  def show
    @offer = Offer.find_by(id: params[:id])
    @author = @offer.user
    @nft_id = SignNftRequest.last.count
    @bids = @offer.bids
    @can_claim_bid = DateTime.now > @offer.end_date
    @highest_bid_id = @bids.order('amount DESC').first.id if @bids.any?
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
