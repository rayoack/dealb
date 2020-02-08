class CreateInvestorStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :investor_statuses do |t|
      t.string :name

      t.timestamps
    end

    InvestorStatus.create :name => "ACTIVE"
    InvestorStatus.create :name => "INACTIVE"
    InvestorStatus.create :name => "ACQUIRED"
  end
end
