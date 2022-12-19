json.posts do
  json.partial! "api/v1/feeds/post", collection: @posts, as: :post
end
json.meta paginate(@posts)
