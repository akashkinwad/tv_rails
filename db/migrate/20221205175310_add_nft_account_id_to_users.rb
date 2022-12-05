class AddNftAccountIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nft_account_id, :string
  end
end
