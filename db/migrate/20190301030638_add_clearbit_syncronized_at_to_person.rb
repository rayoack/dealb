class AddClearbitSyncronizedAtToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :clearbit_syncronized_at, :datetime
  end
end
