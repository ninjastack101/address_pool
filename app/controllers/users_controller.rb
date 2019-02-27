class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_address
    if current_user.address.blank?
      address = get_address
      update_address_and_assign_message(address)
    end
  end

  def assign_address
    address = get_address
    update_address_and_assign_message(address)
    redirect_to my_address_path
  end

  private
  def get_address
    address_key = Figaro.env.REDIS_ADDRESS_KEY
    address = $redis.spop(address_key)
  end

  def update_address_and_assign_message(address)
    return flash[:error] = t('users.address_pool_empty', time: get_remaining_time) if address.blank?
    return flash[:notice] = t('users.address_assigned_successfully') if current_user.update(address: address)
    flash[:error] = t('users.unable_to_assign_address')
  end

  def get_remaining_time
    last_run_at = $redis.get(Figaro.env.REDIS_LAST_RUN_KEY).to_i
    return 1 if last_run_at == 0
    time_diff = (Time.zone.now - Time.zone.at(last_run_at.to_i)).to_i
    time_escaped = time_diff > 60 ? (time_diff / 60) : 1
    12 - time_escaped
  end
end
