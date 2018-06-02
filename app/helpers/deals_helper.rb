# frozen_string_literal: true

module DealsHelper
  def company_link(deal, company = deal.company)
    link = (company.website_url || company.linkedin_url || company.facebook_url)

    link ? link_to(company.name, link) : company.name
  end

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

    deal.deal_investors.map(&:investor).map(&to_link).join(', ').html_safe
  end
end
