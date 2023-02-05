class AddSupplyToNftPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_posts, :total_supplied, :integer, default: 0
    add_column :nft_posts, :available_supply, :integer, default: 0
  end
end
