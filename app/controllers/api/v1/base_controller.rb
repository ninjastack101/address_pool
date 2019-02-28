class Api::V1::BaseController < ApplicationController
  before_action :authorize_user_doorkeeper_access
  before_action :doorkeeper_authorize!
  respond_to :json

  private

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def authorize_user_doorkeeper_access
    current_user
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { message: error&.description } }
  end

  def render_unauthorized_error_response(message)
    render_response(message, 401)
  end

  def render_error_response(message, data = {})
    render_response(message, 400, data)
  end

  def render_success_response(message, data = {})
    render_response(message, 200, data)
  end

  def render_not_found_response(message)
    render_response(message, 404)
  end

  def render_response(message, code, data = {})
    render json: { response: { message: message, data: data } }, status: code
  end
end
