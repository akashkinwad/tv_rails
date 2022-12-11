class CreateSignNftRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :sign_nft_requests do |t|
      t.integer :count

      t.timestamps
    end
  end
end
