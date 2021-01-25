# frozen_string_literal: true

FactoryBot.define do
  factory :deal do
    close_date { Faker::Date.backward }
    status {Deal::UNVERIFIED}
    category {Deal::RAISED_FUNDS_FROM}
    round {Deal::ROUNDS.sample} # eg.: Deal::IPO
    amount_currency {Deal::CURRENCIES.sample} # eg.: Deal::USD
    amount { Faker::Number.between(from: 1, to: 10_000_000_00) }
    pre_valuation_currency {Deal::CURRENCIES.sample} # eg.: Deal::USD
    pre_valuation { Faker::Number.between(from: 1, to: 10_000_000_00) }
    source_url { Faker::Internet.url }

    company
    user
  end
end
