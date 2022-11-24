class AddNftAccountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nft_account, :string
  end
end
