# frozen_string_literal: true

module HomeHelper
  include ActionView::Helpers::NumberHelper

  def latest_updates
    Deal.order(close_date: :asc).last(7).map do |deal|
      description = "#{deal.company&.name} raised " \
        "#{format_amount(deal.amount, deal.amount_currency)} " \
        "from #{deal.investors.map(&:name).join(', ')}"

      { id: deal.id, description: description, date: deal.close_date }
    end
  end
end
