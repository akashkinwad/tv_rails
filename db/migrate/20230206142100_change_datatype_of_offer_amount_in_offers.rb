class ChangeDatatypeOfOfferAmountInOffers < ActiveRecord::Migration[7.0]
  def change
    change_column :offers, :offer_amount, :integer
  end
end
