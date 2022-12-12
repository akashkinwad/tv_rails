class AddOfferIdToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :offer_id, :bigint
  end
end
