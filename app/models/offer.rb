class Offer < ApplicationRecord
  validates :amount, presence: true

  belongs_to :user
  belongs_to :nft_post

  before_create :details_to_json
  after_create :update_nft_offer_id_to_post

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end

  def update_nft_offer_id_to_post
    if nft_post.nft_offer_id.nil?
      offer_id = details.dig('events', 'CreatedOffer', 'returnValues', 'id')
      nft_post.update(nft_offer_id: offer_id)
    end
  end
end
