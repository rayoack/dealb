# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportCompanyMarket
    def run
      Rails.logger.info('-- company')
      ImportOldDatabaseService::Entities::CompanyMarket.all.each do |company_market|
        printf('.')
        old_market = ImportOldDatabaseService::Entities::Market.find(
          company_market.market_id
        )
        old_company = ImportOldDatabaseService::Entities::Company.find(
          company_market.company_id
        )
        new_market = ::Market.find_by!(name: old_market.name)
        new_company = ::Company.find_by!(name: old_company.name)
        ::CompanyMarket.create!(market: new_market, company: new_company)
      end
      Rails.logger.info("-- imported #{::CompanyMarket.count} company markets")
    end

    def update
      Rails.logger.info('-- update company market')
      ImportOldDatabaseService::Entities::CompanyMarket.all.each do |company_market|
        old_market = ImportOldDatabaseService::Entities::Market.find(
          company_market.market_id
        )
        old_company = ImportOldDatabaseService::Entities::Company.find(
          company_market.company_id
        )
        new_market = ::Market.find_by!(name: old_market.name)
        new_company = ::Company.find_by!(name: old_company.name)
        if !::CompanyMarket.exists?(market: new_market, company: new_company)
          ::CompanyMarket.create!(market: new_market, company: new_company)
        end
      end
      Rails.logger.info('-- end update company market')
    end
  end
end
