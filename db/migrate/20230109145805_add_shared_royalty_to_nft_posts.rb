class AddSharedRoyaltyToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :shared_royalty, :decimal
  end
end
