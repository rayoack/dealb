require 'csv'

namespace :deals do
  task amount_fix: :environment do |_task, _args|
    puts('---- Starting Deals update from CSV ----')

    CSV.foreach('./deals.csv') do |row|
      company_name = row.first.presence
      close_date = row.second.presence
      amount = row[6]&.to_i

      org = Company.find_by(name: company_name)

      next if org.empty?

      deal = Deal.find_by(company: org, close_date: close_date)

      next if deal.blank? || amount.positive?

      deal.amount_cents = amount * 100
      deal.save!(validate: false)

      puts("-- Updated Deal, ID: #{deal.id}")
    end

    puts('---- Finished Deals update from CSV ----')
  end
end
