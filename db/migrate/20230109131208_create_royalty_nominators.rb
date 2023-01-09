class CreateRoyaltyNominators < ActiveRecord::Migration[7.0]
  def change
    create_table :royalty_nominators do |t|
      t.references :nft_post, null: false, foreign_key: true
      t.string :payee_address
      t.decimal :shares

      t.timestamps
    end
  end
end
