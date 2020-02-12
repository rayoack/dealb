class CreateIndustryGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :industry_groups do |t|
      t.string :name, null: false, index: true
      t.belongs_to :sector, foreign_key: true

      t.timestamps
    end
  end
end
