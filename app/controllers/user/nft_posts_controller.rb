class User::NftPostsController < ApplicationController
  layout 'user'

  include UploadToS3

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def new
    @nft_post = current_user.nft_posts.new
  end

  def create
    @nft_post = current_user.nft_posts.new(nft_post_params.except(:attachment))

    respond_to do |format|
      if @nft_post.save
        upload_and_set_attr(nft_post_params.dig(:attachment))

        format.html { redirect_to user_nft_post_url(@nft_post), notice: "Post was successfully created." }
        format.json { render json: @nft_post, status: :created }
        format.js   { render :new, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js { render json: @nft_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def explore
    @nft_posts = NftPost.includes(:user, :likes)
  end

  def show
    @nft_post = NftPost.find_by(id: params[:id])
    @author = @nft_post.user
    @nft_id = SignNftRequest.last.count
    @offers = @nft_post.offers
    @can_claim_offer = DateTime.now > @nft_post.end_date
    @highest_offer_id = @offers.order('amount DESC').first.id if @offers
  end

  def mobile_nft;end

  private
    def nft_post_params
      params.require(:nft_post).permit(
        :title,
        :description,
        :category,
        :hashtags,
        :offer_amount,
        :max_supply,
        :attachment,
        :attachment_url,
        :details,
        :start_price,
        :target_price,
        :end_date,
        :nft_id
      )
    end

    def upload_and_set_attr(file)
      if file
        extension = File.extname(file)

        folder_path = "#{Rails.env}/#{current_user.id}/nft_posts/#{@nft_post.id}/#{Time.now.to_i}-#{file.original_filename}"
        upload_object = upload_to_s3(file, folder_path)
        @nft_post.update(
          attachment_url: upload_object.public_url,
          content_type: file.content_type,
          extension: extension
        ) if upload_object
      end
    end
end
