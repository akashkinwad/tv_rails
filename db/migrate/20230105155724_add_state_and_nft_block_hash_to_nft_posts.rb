class AddStateAndNftBlockHashToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :state, :integer, default: 0
    add_column :nft_posts, :nft_block_hash, :string
  end
end
