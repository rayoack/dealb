class AddClearbitSynchronizedAtToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :clearbit_synchronized_at, :datetime
    
    rename_column :people, :clearbit_syncronized_at, :clearbit_synchronized_at
  end
end
