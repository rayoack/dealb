module Integrations
  # Github integration client
  class Github
    class << self
      def all_contributors(except: [])
        contributors = dealbook_contributors&.reject! do |user|
          user[:login].in?(except)
        end

        return [] if contributors.blank?

        contributors.map do |user|
          client.user(user[:login])
        end
      end

      private

      ACCESS_TOKEN = ENV['DEALBOOK_GITHUB_ACCESS_TOKEN'].freeze

      def client
        @client ||= Octokit::Client.new(access_token: ACCESS_TOKEN)
      end

      def dealbook_contributors
        client.contributors('bossabox/dealbook')
      end
    end
  end
end
