module Devise
  class UsersMailer < Devise::Mailer
    include Devise::Controllers::UrlHelpers

    helper :application

    default from: "dontreply@#{ENV.fetch('DEALBOOK_MAILGUN_DOMAIN')}",
            template_path: 'devise/mailer'

    def confirmation_instructions(record, token, opts = {})
      super
    end
  end
end
