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
    
    def update
      Rails.logger.info('-- update market')
      ImportOldDatabaseService::Entities::Market.find_each do |market|
        if !::Market.exists?(name: market.name)
          ::Market.create!(name: market.name)
        end
      end
      Rails.logger.info('-- end update market')
    end
  end
end
