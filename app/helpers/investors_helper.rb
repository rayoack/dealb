# frozen_string_literal: true

module InvestorsHelper
  def possible_new_investors
    people = Person.all.collect do |p|
      ["#{p.name}- Person", p.permalink]
    end

    companies = Company.all.collect do |p|
      ["#{p.name}- Company", p.permalink]
    end

    Array(people + companies)
  end
end
