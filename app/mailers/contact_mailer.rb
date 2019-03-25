# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def index(params)
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @message = params.fetch(:message)

    mail(
      to: @email,
      subject: "[Contact from site Dealbook] Name: #{@name} Email: #{@email}"
    )
  end
end
