class AddClaimerDetailsToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :claimer_id, :integer
    add_column :nft_posts, :claimer_wallet_address, :string
    add_index :nft_posts, :claimer_id
  end
end
