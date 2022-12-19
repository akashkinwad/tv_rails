class RenameColumnsOfNftPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :nft_posts, :listing_price, :offer_amount
    rename_column :nft_posts, :quantity, :max_supply

    change_column :nft_posts, :offer_amount, :integer
  end
end
