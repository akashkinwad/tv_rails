class ApplicationController < ActionController::Base
  before_action :increment_sign_nft_count

  def after_sign_in_path_for(resource)
    if resource.class.to_s == 'Admin'
      admin_users_path
    else
      new_user_nft_post_path
    end
  end

  def increment_sign_nft_count
    if action_name == 'sign_nft'
      SignNftRequest.create
    end
  end
end
