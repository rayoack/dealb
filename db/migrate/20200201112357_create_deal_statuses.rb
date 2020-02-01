class CreateDealStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :deal_statuses do |t|
      t.string :name

      t.timestamps
    end

    DealStatus.create :name => "UNVERIFIED"
    DealStatus.create :name => "VERIFIED"
  end
end
