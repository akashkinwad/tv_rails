class RenameOfferIdOfNftPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :nft_posts, :offer_id, :nft_offer_id
  end
end
