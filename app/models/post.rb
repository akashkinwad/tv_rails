class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  def render_json
    {
      post: self,
      user: user,
      comments: comments
    }
  end
end
