# frozen_string_literal: true
class Api::V1::UsersController < Api::V1::BaseController
  include UsersConcern

  def my_address
    if current_user.address.blank?
      update_address_and_assign_message(fetch_address)
    else
      render_success_response(
        t(
          'users.address',
          address: current_user.address
        )
      )
    end
  end

  def assign_address
    update_address_and_assign_message(fetch_address)
  end

  private

  def update_address_and_assign_message(address)
    return render_error_response(
      t('users.address_pool_empty', time: fetch_remaining_time)
    ) if address.blank?

    return render_success_response(
      t('users.address_assigned_successfully'), address: address
    ) if current_user.update(address: address)

    render_error_response(t('users.unable_to_assign_address'))
  end
end
