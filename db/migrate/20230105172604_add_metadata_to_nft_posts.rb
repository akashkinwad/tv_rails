class AddMetadataToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :metadata, :jsonb
  end
end
