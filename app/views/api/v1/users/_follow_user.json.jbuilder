json.user do
  json.id user.id
  json.email user.email
  json.first_name user.first_name
  json.last_name user.last_name
  json.username user.username
  json.image_url user.image_url
  json.blr_image user.blr_image
  json.video_url user.video_url
  json.is_followed user.following_users.where(follower_id: current_user.id).exists?
  json.followers_count user.following_users.count
  json.following_count user.followed_users.count
end
