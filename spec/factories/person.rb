# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    permalink { [first_name.to_s + last_name.to_s].join(' ').parameterize }
    description { Faker::Lorem.paragraph }

    # Optionals
    born_on { Faker::Date.backward }
    gender {Person::MALE}
    phone_number {'55 11 99999-0077'}
    occupation { Faker::Name.title }
    email { Faker::Internet.email }
    website_url { 'http://www.apple.com' }
    facebook_url { 'https://www.facebook.com/apple' }
    twitter_url { 'https://twitter.com/apple' }
    google_plus_url { 'https://googleplus.com/apple' }
    linkedin_url { 'https://linkedin.com/stevejobs' }
    profile_image_url { 'https://google.com' }
  end
end
