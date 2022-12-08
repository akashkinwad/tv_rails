class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if resource.class.to_s == 'Admin'
      admin_users_path
    else
      new_user_nft_post_path
    end
  end
end
