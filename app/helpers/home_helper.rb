# frozen_string_literal: true

module HomeHelper
  include ActionView::Helpers::NumberHelper

  def formatted_updates(deals)
    deals.map do |deal|
      if deal.amount
        amount = "#{format_amount(deal.amount, deal.amount_currency)} "
      else
        amount = " founds "
      end
      
      description = "#{deal&.company_name} raised " \
        "#{amount}" \
        "from #{deal.investors.map(&:name).join(', ')}"

      { id: deal.id, description: description, date: deal.close_date }
    end
  end
end
