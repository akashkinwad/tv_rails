class RenameNftBlockHashToNftTokenIdOfNftPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :nft_posts, :nft_block_hash, :nft_token_id
  end
end
