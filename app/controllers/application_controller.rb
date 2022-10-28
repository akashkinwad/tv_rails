class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if resource.class.to_s == 'Admin'
      admin_users_path
    else
      root_path
    end
  end
end
