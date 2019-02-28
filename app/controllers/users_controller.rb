class UsersController < ApplicationController
  include UsersConcern
  before_action :authenticate_user!

  def my_address
    return unless current_user.address.blank?
    update_address_and_assign_message(fetch_address)
  end

  def assign_address
    update_address_and_assign_message(fetch_address)
    redirect_to my_address_path
  end

  private

  def update_address_and_assign_message(address)
    return flash[:error] = t('users.address_pool_empty', time: fetch_remaining_time) if address.blank?
    return flash[:notice] = t('users.address_assigned_successfully') if current_user.update(address: address)
    flash[:error] = t('users.unable_to_assign_address')
  end
end
