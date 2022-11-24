class NftPost < ApplicationRecord
  validates :title, :description, :listing_price, presence: true
  validates :attachment_url, presence: true, on: :update

  belongs_to :user
end
