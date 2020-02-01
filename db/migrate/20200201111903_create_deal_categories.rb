class CreateDealCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :deal_categories do |t|
      t.string :name, null: false, index: true
      t.timestamps
    end

    DealCategory.create :name => "Raised Funds From"
    DealCategory.create :name => "Incubated by"
    DealCategory.create :name => "Merged With"
    DealCategory.create :name => "Acquired By"
    DealCategory.create :name => "Shutdown"
  end
end
