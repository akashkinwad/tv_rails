class RenameTokenUriOfNftPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :nft_posts, :token_uri, :token_url
  end
end
