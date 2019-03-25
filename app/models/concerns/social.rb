# Module to share Social Information
module Social
  extend ActiveSupport::Concern

  URLS = {
    facebook: 'https://facebook.com/',
    linkedin: 'https://linkedin.com/',
    twitter: 'https://twitter.com/',
    crunchbase: 'https://crunchbase.com/'
  }.freeze

  included do
    def update_from_clearbit(data)
      new_attributes = attributes.reject { |_, v| v.nil? }
                                 .reverse_merge(data)
      new_attributes[:clearbit_synchronized_at] = Time.zone.now
      update!(new_attributes)
    end
  end
end
