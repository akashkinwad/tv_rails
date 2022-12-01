json.array! @nft_posts do |nft_post|
  json.partial! "api/v1/nft_posts/nft_post", nft_post: nft_post
end
