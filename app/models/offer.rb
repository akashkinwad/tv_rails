class Offer < ApplicationRecord
  validates :title,
            :description,
            :offer_amount,
            :start_price,
            :target_price,
            presence: true

  enum :state, { created: 0, minted: 1 }, prefix: true, scope: true

  belongs_to :user
  belongs_to :nft_post
  belongs_to :claimer, class_name: 'User', optional: true

  has_many :bids, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  before_save :details_to_json
  before_save :set_dummy_nft_token_id
  before_save :set_token_url
  before_save :set_metadata

  after_update :change_nft_post_supply_details
  after_update :create_available_offer

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end

  def set_dummy_nft_token_id
    self.nft_token_id = SecureRandom.uuid if nft_token_id.nil?
  end

  def set_token_url
    self.token_url = "#{ENV['HOST']}/nfts/#{nft_token_id}"
  end

  def set_metadata
    selected_attrs = %w[title description category hashtags
      offer_amount max_supply token_url attachment_url content_type
      extension start_price target_price end_date state
    ]

    self.metadata = self.attributes.slice(*selected_attrs)
  end

  # increment total supplied, decrement available supply
  # skip callbacks to avoid after update callbacks
  def change_nft_post_supply_details
    return unless state_changed_from_created_to_minted?

    total_supplied = nft_post.total_supplied + 1
    available_supply = nft_post.max_supply - total_supplied

    nft_post.update(
      total_supplied: total_supplied,
      available_supply: available_supply,
      skip_callbacks: true
    )
  end

  def state_changed_from_created_to_minted?
    state_previously_changed? && state_previously_was == 'created'
  end

  def create_available_offer
    return unless state_changed_from_created_to_minted?
    return if nft_post.available_supply.zero?

    new_offer = self.dup
    new_offer.update(nft_token_id: nil, metadata: nil, state: 'created')
  end
end
