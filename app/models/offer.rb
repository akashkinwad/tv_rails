class Offer < ApplicationRecord
  validates :amount, presence: true

  belongs_to :user
  belongs_to :nft_post

  before_create :details_to_json
  before_create :update_nft_offer_id_to_post

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end

  def update_nft_offer_id_to_post
    if details.is_a? Integer
      nft_post.update(nft_offer_id: details)
    end
  end
end
