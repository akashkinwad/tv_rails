class SignNftRequest < ApplicationRecord
  before_create :increment_count, unless: :skip_callbacks

  def increment_count
    self.count = SignNftRequest.maximum(:count).next
  end
end
