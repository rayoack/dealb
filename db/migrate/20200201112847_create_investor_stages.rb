class CreateInvestorStages < ActiveRecord::Migration[5.1]
  def change
    create_table :investor_stages do |t|
      t.string :name

      t.timestamps
    end

    InvestorStage.create :name => "Angel"
    InvestorStage.create :name => "Pre-Seed"
    InvestorStage.create :name => "Seed"
    InvestorStage.create :name => "Series A"
    InvestorStage.create :name => "Series B"
    InvestorStage.create :name => "Series C"
    InvestorStage.create :name => "Series D"
    InvestorStage.create :name => "Series E"
    InvestorStage.create :name => "Series F"
    InvestorStage.create :name => "Series G"
    InvestorStage.create :name => "Series H"
    InvestorStage.create :name => "Debt Financing"
    InvestorStage.create :name => "IPO"
  end
end
