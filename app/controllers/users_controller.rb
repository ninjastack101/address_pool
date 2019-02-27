class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_address; end
end
