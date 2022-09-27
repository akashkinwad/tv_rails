class Like < ApplicationRecord

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:likeable_id, :likeable_type] }
  validates :value, inclusion: 0..4
end
