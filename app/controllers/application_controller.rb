# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[index show]

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
end
