# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def linkedin
      info = request.env['omniauth.auth'].try(:[], :info)&.deep_symbolize_keys
      person = Person.create(first_name: info[:first_name],
                             last_name: info[:last_name],
                             email: info[:email],
                             occupation: info[:headline],
                             description: info[:description],
                             linkedin_url: info[:urls][:public_profile],
                             image_url: info[:image])

      @user = User.from_omniauth(request.env['omniauth.auth'])
      @user.update(person: person)
      sign_in_and_redirect(@user, event: :authentication)

      flash = is_navigational_format?
      set_flash_message(:notice, :success, kind: 'LinkedIn') if flash
    end
  end
end
