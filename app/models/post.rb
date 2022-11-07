class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :parent_comments, -> { only_parents }, class_name: 'Comment'
  has_many :likes, as: :likeable, dependent: :destroy

  validates :url, :title, presence: true

  def to_json
    attributes.merge(likes: likes.count)
  end
end
