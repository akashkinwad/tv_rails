class NftPost < ApplicationRecord

  enum :state, { created: 0, minted: 1 }, prefix: true, scope: true

  validates :title,
            :description,
            :offer_amount,
            :max_supply,
            :start_price,
            :target_price,
            presence: true

  # validates :attachment_url, presence: true, on: :update

  belongs_to :user
  belongs_to :claimer, class_name: 'User', optional: true
  has_many :offers, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :royalty_nominators, dependent: :destroy

  accepts_nested_attributes_for :royalty_nominators, reject_if: :all_blank, allow_destroy: true

  before_create :set_available_supply
  after_create :create_offer
  after_update :set_attachment_details_for_offer, unless: :skip_callbacks

  private

  def set_available_supply
    self.available_supply = max_supply
  end

  def create_offer
    self.offers.create(
      user: user,
      title: title,
      description: description,
      category: category,
      hashtags: hashtags,
      offer_amount: offer_amount,
      attachment_url: attachment_url,
      content_type: content_type,
      extension: extension,
      start_price: start_price,
      target_price: target_price,
      end_date: end_date,
    )
  end

  def set_attachment_details_for_offer
    return if attachment_url.nil?

    offers.update(
      attachment_url: attachment_url,
      content_type: content_type,
      extension: extension
    )
  end
end
