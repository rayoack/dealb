namespace :db_import do
  desc 'update markets from old db'
  task market: :environment do
    ImportOldDatabaseService::ImportMarket.new.update
  end

  desc 'import old db location'
  task location: :environment do
    ImportOldDatabaseService::ImportLocation.new.update
  end

  desc 'import old db user'
  task user: :environment do
    ImportOldDatabaseService::ImportUser.new.update
  end

  desc 'import old db company'
  task company: :environment do
    ImportOldDatabaseService::ImportCompany.new.update
  end

  desc 'import old db company market'
  task company_market: :environment do
    ImportOldDatabaseService::ImportCompanyMarket.new.update
  end

  desc 'import old db company location'
  task company_location: :environment do
    ImportOldDatabaseService::ImportCompanyLocation.new.update
  end

  desc 'import old db deal'
  task deal: :environment do
    ImportOldDatabaseService::ImportDeal.new.update
  end

  desc 'import old db investor'
  task investor: :environment do
    investor = ImportOldDatabaseService::ImportInvestor.new.update
    investor.present?
    # investor_location = ImportOldDatabaseService::ImportInvestorLocation.new.update
    # investor_location.present?
    investor_market = ImportOldDatabaseService::ImportInvestorMarket.new.update
    investor_market.present?
    ImportOldDatabaseService::ImportDealing.new.update
  end

  desc 'import old db first'
  task base: :environment do
    user = ImportOldDatabaseService::ImportUser.new.update
    user.present?
    market = ImportOldDatabaseService::ImportMarket.new.update
    market.present?
    company = ImportOldDatabaseService::ImportCompany.new.update
    company.present?
    company_market = ImportOldDatabaseService::ImportCompanyMarket.new.update
    company_market.present?
    location = ImportOldDatabaseService::ImportLocation.new.update
    location.present?
    company_location = ImportOldDatabaseService::ImportCompanyLocation.new.update
    company_location.present?
    ImportOldDatabaseService::ImportDeal.new.update
  end

  desc 'import old db location link'
  task location_link: :environment do
    Rails.logger.info('IMPORT - update db with old data')
    company_location = ImportOldDatabaseService::ImportCompanyLocation.new.update
    company_location.present?
    investor_location = ImportOldDatabaseService::ImportInvestorLocation.new.update
    Rails.logger.info('END IMPORT')
  end

  desc 'import old db all'
  task all: :environment do
    Rails.logger.info('IMPORT - update db with old data')
    user = ImportOldDatabaseService::ImportUser.new.update
    user.present?
    market = ImportOldDatabaseService::ImportMarket.new.update
    market.present?
    company = ImportOldDatabaseService::ImportCompany.new.update
    company.present?
    company_market = ImportOldDatabaseService::ImportCompanyMarket.new.update
    company_market.present?
    location = ImportOldDatabaseService::ImportLocation.new.update
    location.present?
    # company_location = ImportOldDatabaseService::ImportCompanyLocation.new.update
    # company_location.present?
    deal = ImportOldDatabaseService::ImportDeal.new.update
    deal.present?
    investor = ImportOldDatabaseService::ImportInvestor.new.update
    investor.present?
    # investor_location = ImportOldDatabaseService::ImportInvestorLocation.new.update
    # investor_location.present?
    investor_market = ImportOldDatabaseService::ImportInvestorMarket.new.update
    investor_market.present?
    dealing = ImportOldDatabaseService::ImportDealing.new.update
    dealing.present?
    results = ActiveRecord::Base.connection.execute("update investors set investable_type = 'Person' where investable_type = 'MyPerson'; update investors set investable_type = 'Company' where investable_type = 'MyCompany';");
    Rails.logger.info('END IMPORT')

    # Rails.logger.debug('-- debug')
    # Rails.logger.info('-- info')
    # Rails.logger.warn('-- warn')
    # Rails.logger.error('-- error')
    # Rails.logger.fatal('-- fatal')
    # Rails.logger.unknown('-- unknown')
  end

end
