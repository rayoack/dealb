class CreateDealRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :deal_rounds do |t|
      t.string :name

      t.timestamps
    end

    DealRound.create :name => "Acceleration"
    DealRound.create :name => "Seed"
    DealRound.create :name => "Series A"
    DealRound.create :name => "Series B"
    DealRound.create :name => "Series C"
    DealRound.create :name => "Series D"
    DealRound.create :name => "Series E"
    DealRound.create :name => "Series F"
    DealRound.create :name => "Series G"
    DealRound.create :name => "Series H"
    DealRound.create :name => "IPO"
    DealRound.create :name => "Pre Seed"
    DealRound.create :name => "Angel"
    DealRound.create :name => "Venture"
    DealRound.create :name => "Crowdfunding"
    DealRound.create :name => "Private Equity"
    DealRound.create :name => "Secondary"
    DealRound.create :name => "Grant"
    DealRound.create :name => "IPO Follow On"
  end
end
