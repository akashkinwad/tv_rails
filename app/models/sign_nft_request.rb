class SignNftRequest < ApplicationRecord
  before_create :increment_count

  def increment_count
    self.count = SignNftRequest.maximum(:count).next
  end
end
