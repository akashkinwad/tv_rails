class AddColumnsToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :start_price, :decimal
    add_column :nft_posts, :target_price, :decimal
    add_column :nft_posts, :end_date, :datetime
    add_column :nft_posts, :nft_id, :integer
  end
end
