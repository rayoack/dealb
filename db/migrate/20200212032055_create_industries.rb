class CreateIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :industries do |t|
      t.string :name, null: false, index: true
      t.belongs_to :industry_group, foreign_key: true

      t.timestamps
    end
  end
end
