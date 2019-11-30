# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportMarket
    def run
      Rails.logger.info('-- market')
      ImportOldDatabaseService::Entities::Market.find_each do |market|
        printf('.')
        ::Market.create!(name: market.name)
      end
      Rails.logger.info("-- imported #{::Market.count} markets")
    end
  end
end
