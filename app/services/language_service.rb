# frozen_string_literal: true

class LanguageService
  def initialize(params, session, http_accept_language)
    @params = params
    @session = session
    @http_accept_language = http_accept_language
  end

  def set_language
    if params[:language]
      define_language
    else
      define_language_from_browser
    end

    log_language && true
  end

  private

  attr_reader :params, :session, :http_accept_language

  def define_language
    session[:language] = params[:language]
    I18n.locale = params[:language]
  end

  def define_language_from_browser
    language = http_accept_language.compatible_language_from(
      I18n.available_locales
    )

    session[:language] = language
    I18n.locale = language
  end

  def log_language
    Rails.logger.debug("* Language set to '#{I18n.locale}'")
  end
end
