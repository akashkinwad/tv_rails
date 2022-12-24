module UsersHelper

  def profile_url(user)
    user.image_url || '/user/img/default/img-1.png'
  end

  def can_claim_offer?(nft_post, offer_id)
    offers = nft_post.offers
    is_offer_expired = DateTime.now > nft_post.end_date
    highest_offer_id = offers.order('amount DESC').first.id if offers

    is_offer_expired && (highest_offer_id == offer_id)
  end
end
