# frozen_string_literal: true

source 'https://rubygems.org'

ruby '>=2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'sentry-raven'
gem 'sitemap_generator'

gem 'aws-sdk-core'
gem 'aws-sdk-s3'
gem 'fog-aws'

gem 'sendgrid-ruby'

gem 'activevalidators', '~> 4.1'
gem 'clearbit', '~> 0.3'
gem 'jbuilder', '~> 2.5'
gem 'http_accept_language', '~> 2.1.1'
gem 'kaminari'
gem 'mailgun-ruby', '~>1.1.6'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.1.6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'devise', '~> 4.4'
gem 'omniauth'
gem 'omniauth-linkedin-oauth2'

gem 'figaro'

gem 'octokit', '~> 4.0'
gem 'premailer-rails'

# Generates new spreadsheets in XLSX
gem 'zip-zip'
gem 'axlsx'
gem 'axlsx_rails'

group :development, :test do
  gem 'capybara', '~> 2.13'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.6'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1', require: false
  gem 'execjs'
  gem 'therubyracer'
  gem 'travis'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'reek'
  gem 'rubocop'
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener'
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
