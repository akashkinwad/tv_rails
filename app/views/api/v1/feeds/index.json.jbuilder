json.array! @posts do |post|
  json.partial! "api/v1/feeds/post", post: post
end
