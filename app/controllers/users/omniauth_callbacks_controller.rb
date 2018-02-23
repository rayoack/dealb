# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def linkedin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      sign_in_and_redirect(@user, event: :authentication)

      set_flash_message(
        :notice, :success, kind: 'LinkedIn'
      ) if is_navigational_format?
    end
  end
end
