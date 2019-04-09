# frozen_string_literal: true

module ApplicationHelper
  def language_flag
    if session[:language] || I18n.locale
      "flag-#{I18n.locale}.svg"
    else
      'language.svg'
    end
  end

  def format_amount(amount, currency = Deal::USD)
    unit = {
      Deal::USD => 'USD',
      Deal::BRL => 'R$'
    }.fetch(currency, currency)

    number_to_currency(number_to_human(amount, precision: 2), unit: unit)
  end
end
