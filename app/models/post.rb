class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  def render_json
    {
      post: self,
      comments: comments
    }
  end
end
