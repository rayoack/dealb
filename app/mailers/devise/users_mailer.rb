module Devise
  class UsersMailer < Devise::Mailer
    include Devise::Controllers::UrlHelpers

    layout 'mailer'

    helper :application

    default from: "Dealbook <dontreply@#{ENV.fetch('DEALBOOK_MAILGUN_DOMAIN')}>"

    def confirmation_instructions(record, token, opts = {})
      super
    end
  end
end
