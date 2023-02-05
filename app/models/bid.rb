class Bid < ApplicationRecord
  validates :amount, presence: true

  belongs_to :offer
  belongs_to :user

  before_create :details_to_json
  after_create :update_nft_offer_id_to_offer

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end

  def update_nft_offer_id_to_offer
    if offer.nft_offer_id.nil?
      offer_id = details.dig('events', 'CreatedOffer', 'returnValues', 'offerId')
      offer.update(nft_offer_id: offer_id)
    end
  end
end
