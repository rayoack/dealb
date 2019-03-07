# Module to share Social Information
module Social
  extend ActiveSupport::Concern

  URLS = {
    facebook: 'https://facebook.com/',
    linkedin: 'https://linkedin.com/',
    twitter: 'https://twitter.com/',
    crunchbase: 'https://crunchbase.com/'
  }.freeze
end
