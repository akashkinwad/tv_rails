class NftPost < ApplicationRecord
  validates :title,
            :description,
            :listing_price,
            :nft_id,
            :start_price,
            :target_price,
            presence: true

  validates :attachment_url, presence: true, on: :update

  belongs_to :user

  before_create :details_to_json

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end
end
