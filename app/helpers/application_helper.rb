# frozen_string_literal: true

module ApplicationHelper
  def language_flag
    if session[:language]
      "flag-#{session[:language]}.svg"
    else
      'language.svg'
    end
  end
end
