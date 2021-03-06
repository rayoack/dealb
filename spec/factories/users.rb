# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'test1020' }
    password_confirmation { 'test1020' }
    confirmed_at { Time.zone.now }

    person {nil}
  end
end
