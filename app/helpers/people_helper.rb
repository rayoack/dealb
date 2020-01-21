# frozen_string_literal: true

module PeopleHelper
  def latest_company(person, person_companies = person.person_companies)
    return t("empty_state") if person_companies.empty?

    person_companies.map do |person_company|
      link_to(person_company.company.name, "/companies/#{person_company.company.permalink}") if !person_company.company.blank?
    end.join(' / ').html_safe # rubocop:disable Rails/OutputSafety
  end

  def investor_category(person)
    return unless person.investor
    person.investor.tag
  end
end
