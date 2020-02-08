class CreateCompanyStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :company_statuses do |t|
      t.string :name

      t.timestamps
    end

    CompanyStatus.create :name => "ACTIVE"
    CompanyStatus.create :name => "INACTIVE"
    CompanyStatus.create :name => "ACQUIRED"
  end
end
