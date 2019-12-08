# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportInvestorMarket
    # rubocop:disable Metrics/MethodLength
    def run
      @company_market_count_before = ::CompanyMarket.count

      ImportOldDatabaseService::Entities::InvestorMarket
          .all
          .each do |investor_market|
        printf('.')

        @investor_market = investor_market

        @old_market = Entities::Market.find(investor_market.market_id)
        @old_investor = Entities::Investor.find(investor_market.investor_id)

        @company = ::Company.find_by(permalink: @old_investor.slug
                                                             .strip
                                                             .presence)

        next if @company.blank?

        @market = ::Market.find_by!(name: @old_market.name)

        @company_mkt = ::CompanyMarket.new(company: @company, market: @market)

        @company_mkt.save!
      end

      Rails.logger.info("-- imported #{::CompanyMarket.count} investor_markets")
    rescue StandardError
      raise
    end

    def update
      Rails.logger.info('-- update investor market')
      ImportOldDatabaseService::Entities::InvestorMarket.all.each do |investor_market|
        @investor_market = investor_market
  
        @old_investor = Entities::Investor.find(investor_market.investor_id)
        @company = ::Company.find_by(permalink: @old_investor.slug.strip.presence)
        next if @company.blank?
  
        @old_market = Entities::Market.find(investor_market.market_id)
        @market = ::Market.find_by(name: @old_market.name)
        next if @market.blank?
        
        @company_mkt = ::CompanyMarket.find_by(
          company: @company,
          market: @market
        )
        @company_mkt ||= ::CompanyMarket.create!(
          company: @company,
          market: @market
        )
      end
      Rails.logger.info('-- end update investor market')
    end
  end
  # rubocop:enable Metrics/MethodLength
end
