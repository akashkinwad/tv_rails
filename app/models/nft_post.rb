class NftPost < ApplicationRecord

  enum :state, { created: 0, minted: 1 }, prefix: true, scope: true

  validates :title,
            :description,
            :offer_amount,
            :max_supply,
            :start_price,
            :target_price,
            presence: true

  validates :attachment_url, presence: true, on: :update

  belongs_to :user
  has_many :offers, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  before_save :details_to_json
  before_save :set_dummy_nft_block_hash
  before_save :set_token_url
  before_save :set_metadata

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end

  def set_dummy_nft_block_hash
    self.nft_block_hash = SecureRandom.uuid if nft_block_hash.nil?
  end

  def set_token_url
    self.token_url = "#{ENV['HOST']}/nfts/#{nft_block_hash}"
  end

  def set_metadata
    selected_attrs = %w[title description category hashtags
      offer_amount max_supply token_url attachment_url content_type
      extension details start_price target_price end_date state
    ]

    self.metadata = self.attributes.slice(*selected_attrs)
  end
end
