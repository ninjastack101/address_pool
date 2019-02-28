# frozen_string_literal: true

class Api::V1::SessionsController < Api::V1::BaseController

  before_action :set_user, only: %i[sign_in]
  skip_before_action :doorkeeper_authorize!, only: :sign_in

  def sign_in
    return render_unauthorized_error_response(
      t('api.user.invalid_email_or_password')
    ) unless @user&.try(:valid_password?, params[:password])
    create_device_token_with_access_token(@user)
  end

  def sign_out
    doorkeeper_token.destroy
    render_success_response(t('api.user.sign_out'))
  end

  private

  def set_user
    @user = User.find_by(email: params[:email]&.strip)
  end

  def create_device_token_with_access_token(user)
    access_token = user.generate_access_token
    render_success_response(t('api.success'), access_token: access_token.token) if access_token.is_a?(Doorkeeper::AccessToken)
  end
end
