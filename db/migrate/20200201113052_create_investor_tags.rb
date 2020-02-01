class CreateInvestorTags < ActiveRecord::Migration[5.1]
  def change
    create_table :investor_tags do |t|
      t.string :name

      t.timestamps
    end

    InvestorTag.create :name => "Angel"
    InvestorTag.create :name => "Venture Fund"
    InvestorTag.create :name => "Accelerator"
    InvestorTag.create :name => "Incubator"
    InvestorTag.create :name => "Corporate Venture"
    InvestorTag.create :name => "Family Office"
    InvestorTag.create :name => "Private Equity"
    InvestorTag.create :name => "Venture Debt"
  end
end
