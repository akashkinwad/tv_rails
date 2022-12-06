class RenameColumnOfUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :nft_account_id, :wallet_address
  end
end
