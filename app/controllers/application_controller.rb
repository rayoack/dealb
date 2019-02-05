# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from(
    ActionController::RoutingError,
    ActiveRecord::RecordNotFound,
    with: :not_found
  )

  DOMAINS_SWITCH_AVAILABLE = {
    'br.dealbook.co' => 'br',
    'uk.dealbook.co' => 'uk'
  }

  before_action :authenticate_user!, except: %i[index show]

  before_action :set_language

  protect_from_forgery with: :exception

  # This helper methods is for use a login page, out of the the
  # controller defined by devise
  helper_method :resource, :resource_name

  # Overide devise
  def resource_name
    :user
  end

  # Overide devise
  def resource
    @resource ||= User.new
  end

  def set_language
    LanguageService.new(params, cookies, http_accept_language).set_language
  end

  def domain_country_context
    @domain_country_context ||=
      begin
        domain = URI.parse(request.domain).host

        DOMAINS_SWITCH_AVAILABLE.fetch(domain, 'br')
      end
  end

  def user_admin?
    current_user&.role == User::ADMIN
  end
  helper_method :user_admin?

  def user_moderator?
    current_user&.role == User::MODERATOR
  end
  helper_method :user_moderator?

  def after_sign_in_path_for(resource)
    if current_user.status == User::BLOCKED
      '/logout'
    else
      deals_path
    end
  end

  def not_found
    render(file: 'public/404', status: 404, formats: [:html])
  end
end
