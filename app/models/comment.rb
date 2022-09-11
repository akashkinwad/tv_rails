class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :post
  belongs_to :user
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id
end
