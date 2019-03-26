# frozen_string_literal: true

module PeopleHelper
  def latest_company(person, person_companies = person.person_companies)
    current_person_company = person_companies.detect(&:current?)

    if current_person_company
      company = current_person_company.company

      link_to(company.name, company_path(company.permalink))
    elsif person_companies.last
      company = person_companies.last.company

      link_to(company.name, company_path(company.permalink))
    else
      'Unknown'
    end
  end

  def investor_category(person)
    return unless person.investor

    person.investor.tag
  end
end
