json.partial! "api/v1/users/user", user: @user
json.following do
  json.array! @followings do |following|
    json.partial! "api/v1/users/follow_user", user: following
  end
end
