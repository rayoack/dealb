# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Raven.configure do |config|
  config.dsn = ENV.fetch('SENTRY_DSN') { 'https://134895743dd142fbbd18f1fd1e290fba:e487035688ef4ec9b39526eadb235b2a@o429486.ingest.sentry.io/5376165' }
end


module Dealbook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those
    # specified here.  Application configuration should go into files
    # in config/initializers -- all .rb files in that directory are
    # automatically loaded.

    config.autoload_paths += [config.root.join('lib'), config.root.join('app')]
  end
end
