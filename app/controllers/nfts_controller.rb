class NftsController < ApplicationController
  before_action :set_nft_token_id

  def show
    @nft_post = NftPost.find_by(nft_token_id: @nft_token_id)
    data = @nft_post.present? ? @nft_post.metadata : {}

    respond_to do |format|
      format.all { render json: data }
    end
  end

  private

  def set_nft_token_id
    @nft_token_id = params[:id]
    @nft_token_id = @nft_token_id.hex if @nft_token_id.size > 10 && !@nft_token_id.is_a?(Integer)
  end
end
