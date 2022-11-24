class User::NftPostsController < ApplicationController
  include UploadToS3
  layout 'user'
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
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def explore
    @nft_posts = NftPost.includes(:user)
  end

  def show
    @nft_post = NftPost.find_by(id: params[:id])
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def nft_post_params
      params.require(:nft_post).permit(
        :title,
        :description,
        :category,
        :hashtags,
        :listing_price,
        :quantity,
        :attachment,
        :attachment_url
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
