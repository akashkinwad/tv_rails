json.post do
  json.extract! post, :id,
                      :title,
                      :description,
                      :category,
                      :hashtag,
                      :user_id,
                      :created_at,
                      :url,
                      :content_type,
                      :extension,
                      :blr_image,
                      :status

  json.comments post.comments.count
  json.likes post.likes.count
  json.is_liked post.likes.where(user_id: current_user.id).exists?
end
json.partial! "api/v1/users/follow_user", user: post.user
