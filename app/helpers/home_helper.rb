# frozen_string_literal: true

module HomeHelper
  include ActionView::Helpers::NumberHelper

  def formatted_updates(deals)
    deals.map do |deal|
      description = "#{deal.company&.name} raised " \
        "#{format_amount(deal.amount, deal.amount_currency)} " \
        "from #{deal.investors.map(&:name).join(', ')}"

      { id: deal.id, description: description, date: deal.close_date }
    end
  end
end
