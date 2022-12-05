class AddNftDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nft_details, :jsonb
  end
end
