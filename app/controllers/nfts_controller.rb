class NftsController < ApplicationController
  def show
    @nft_post = NftPost.find_by(nft_token_id: params[:id])
    data = @nft_post.present? ? @nft_post.metadata : {}

    respond_to do |format|
      format.all { render json: data }
    end
  end
end
