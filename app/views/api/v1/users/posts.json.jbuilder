if @is_following
  json.posts do
    json.array! @posts do |post|
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
  end
  json.meta paginate(@posts)
end
