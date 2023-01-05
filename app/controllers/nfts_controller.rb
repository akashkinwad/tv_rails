class NftsController < ApplicationController
  # respond_to :json

  def show
    @nft_post = NftPost.find_by(nft_block_hash: params[:id])
    data = @nft_post.present? ? @nft_post.metadata : {}

    respond_to do |format|
      format.all { render json: data }
    end
  end
end
