# frozen_string_literal: true

module DealsHelper
  def investors_link(deal)
    to_link = lambda do |investor|
      investable = investor.investable
      link = (
        investable.website_url ||
        investable.linkedin_url ||
        investable.facebook_url
      )

      link ? link_to(investable.name, link) : investable.name
    end

    deal.deal_investors.map(&:investor).uniq.map(&to_link).join(', ').html_safe
  end
end
