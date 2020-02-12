class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false, index: true

      t.timestamps
    end

    Role.create :name => "communications"
    Role.create :name => "customer_service"
    Role.create :name => "education"
    Role.create :name => "engineering"
    Role.create :name => "finance"
    Role.create :name => "health_professional"
    Role.create :name => "human_resources"
    Role.create :name => "information_technology"
    Role.create :name => "leadership"
    Role.create :name => "legal"
    Role.create :name => "marketing"
    Role.create :name => "operations"
    Role.create :name => "product"
    Role.create :name => "public_relations"
    Role.create :name => "real_estate"
    Role.create :name => "recruiting"
    Role.create :name => "sales"
  end
end
