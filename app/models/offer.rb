class Offer < ApplicationRecord

  validates :amount, presence: true

  belongs_to :user
  belongs_to :post

  before_create :details_to_json

  private

  def details_to_json
    self.details = JSON.parse(self.details) if details
  end
end
