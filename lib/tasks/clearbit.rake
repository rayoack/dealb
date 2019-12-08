require "#{Rails.root}/app/helpers/deals_helper"
include DealsHelper

namespace :clearbit do
  desc 'enrich clearbit'
  task enrich: :environment do
    Rails.logger.info('-- enrich data')
    
    Company.where('clearbit_synchronized_at is null').find_each do |company|
      Integrations::Clearbit.new(company).enrich
      rescue StandardError => e  
        puts e.message
    end

    Person.where('clearbit_synchronized_at is null and email is not null').find_each do |person|
      Integrations::Clearbit.new(person).enrich
      rescue StandardError => e  
        puts e.message
    end
    Rails.logger.info('-- end enrich data')
  end
end
