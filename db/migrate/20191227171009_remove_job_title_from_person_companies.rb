class RemoveJobTitleFromPersonCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :person_companies, :job_title, :string
  end
end
