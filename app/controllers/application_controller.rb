class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  def not_found
    route_not_found
  end

  private

  def route_not_found
    render plain: I18n.t('api.application.no_route', unmatched_route: params[:unmatched_route])
  end

  def after_sign_in_path_for(_resource)
    my_address_path
  end
end
