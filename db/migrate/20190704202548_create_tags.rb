class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :company

      t.timestamps
    end
  end
end
