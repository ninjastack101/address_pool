class ApplicationController < ActionController::Base

  private
  def after_sign_in_path_for(resource)
    my_address_path
  end
end
