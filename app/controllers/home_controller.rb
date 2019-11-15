# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @deals_count = Deal.all.count
    @companies_count = Company.all.count
    @investors_count = Investor.all.count
    @people_count = Person.all.count
    @updates = Deal
                .preload(:investors, :company)
                .left_outer_joins(:company)
                .distinct
                .select('deals.*, companies.name AS company_name')
                .where(close_date: 1.year.ago..Time.zone.now)
                .order(close_date: :asc)
                .last(7)
  end
end
