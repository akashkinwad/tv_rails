json.extract! comment,:id, :body, :user_id, :parent_id
json.username comment.user.username
json.image_url comment.user.image_url
json.likes comment.likes.count
