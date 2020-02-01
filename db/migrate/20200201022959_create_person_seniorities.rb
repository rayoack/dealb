class CreatePersonSeniorities < ActiveRecord::Migration[5.1]
  def change
    create_table :person_seniorities do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    PersonSeniority.create :name => "executive"
    PersonSeniority.create :name => "director"
    PersonSeniority.create :name => "manager"
  end
end
