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
  }.freeze

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :authenticate_user!, except: %i[index show]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  before_action :set_language, if: :change_language?

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
    LanguageService.new(params, session, http_accept_language).set_language
  end

  def change_language?
    return true if session[:language] && params[:language]

    session[:language].nil? && (params[:language] || params[:language].nil?)
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

  def after_sign_in_path_for(_resource)
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
