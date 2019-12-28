class ChangeJobTitleToPersonCompanies < ActiveRecord::Migration[5.1]
  def change
    change_column :person_companies, :job_title, :string, :null => true
  end
end
