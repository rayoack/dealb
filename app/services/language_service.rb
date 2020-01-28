# frozen_string_literal: true

class LanguageService
  def initialize(params, cache, http_accept_language)
    @params = params
    @cache = cache
    @http_accept_language = http_accept_language
  end

  def set_language
    # language = params[:language] || cache['language'] || browser_language
    language = 'en' || params[:language] || cache['language'] || browser_language

    I18n.locale = language
    cache['language'] = language
  end

  private

  attr_reader :params, :cache, :http_accept_language

  def browser_language
    http_accept_language.compatible_language_from(
      I18n.available_locales
    )
  end
end
