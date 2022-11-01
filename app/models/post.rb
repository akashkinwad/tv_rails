class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :parent_comments, -> { only_parents }, class_name: 'Comment'
  has_many :likes, as: :likeable, dependent: :destroy

  def render_json
    {
      post: attributes.merge(likes: likes.count),
      user: user,
      comments: comments
    }
  end

  def to_json
    attributes.merge(likes: likes.count)
  end
end
