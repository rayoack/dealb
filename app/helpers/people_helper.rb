# frozen_string_literal: true

module PeopleHelper
  def latest_company(person, person_companies = person.person_companies)
    current_person_company = person_companies.detect(&:current?)

    if current_person_company
      deal_company_link(current_person_company.company)
    elsif person_companies.last
      deal_company_link(person_companies.last.company)
    else
      'Unknown'
    end
  end

  def investor_category(person)
    return unless person.investor

    person.investor.category
  end

  private

  def deal_company_link(company)
    link = (
      company.website_url || company.linkedin_url || company.facebook_url
    )

    link ? link_to(company.name, link) : company.name
  end
end
