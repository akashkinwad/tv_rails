class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :post
  belongs_to :user

  belongs_to :parent,
            class_name: 'Comment',
            optional: true

  has_many :replies,
          class_name: 'Comment',
          foreign_key: :parent_id,
          dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy

  validate :reply_to_comment, if: :parent_id

  scope :only_parents, -> { where(parent_id: nil) }

  private

  def reply_to_comment
    unless parent.post_id == post_id
      errors.add(:parent_id, 'parent comment is not associated with this post')
    end
  end
end
