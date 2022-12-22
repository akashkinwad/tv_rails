class Post < ApplicationRecord
  enum :status, { active: 0, archived: 1, deleted: 2 }, prefix: true, scope: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :parent_comments, -> { only_parents }, class_name: 'Comment'
  has_many :likes, as: :likeable, dependent: :destroy

  scope :except_deleted, -> { where.not(status: 'deleted') }

  def to_json
    attributes.merge(likes: likes.count)
    attributes.merge(comments_count: comments.count)
  end
end
