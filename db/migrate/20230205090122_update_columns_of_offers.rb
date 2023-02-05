class UpdateColumnsOfOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :title, :string
    add_column :offers, :description, :text
    add_column :offers, :category, :string
    add_column :offers, :hashtags, :text
    add_column :offers, :offer_amount, :decimal
    add_column :offers, :attachment_url, :string
    add_column :offers, :content_type, :string
    add_column :offers, :extension, :string
    add_column :offers, :token_url, :string
    add_column :offers, :start_price, :decimal
    add_column :offers, :target_price, :decimal
    add_column :offers, :end_date, :datetime
    add_column :offers, :state, :integer, default: 0
    add_column :offers, :nft_token_id, :string
    add_column :offers, :metadata, :jsonb
    add_column :offers, :nft_offer_id, :bigint
    add_column :offers, :claimer_id, :integer
    add_column :offers, :claimer_wallet_address, :string

    add_index :offers, :claimer_id
  end
end
