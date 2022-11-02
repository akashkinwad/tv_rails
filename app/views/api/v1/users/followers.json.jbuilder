json.partial! "api/v1/users/user", user: @user
json.followers do
  json.array! @followers do |follower|
    json.partial! "api/v1/users/follow_user", user: follower
  end
end
