module UsersHelper

  def profile_url(user)
    user.image_url || '/user/img/default/img-1.png'
  end
end
