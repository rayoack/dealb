class CreateSubRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_roles do |t|
      t.string :name, null: false, index: true
      t.belongs_to :role, foreign_key: true

      t.timestamps
    end

    communications = Role.find_by(name: "communications")
    SubRole.create :name => "editorial", :role => communications
    SubRole.create :name => "journalist", :role => communications
    SubRole.create :name => "video", :role => communications
    SubRole.create :name => "writer", :role => communications
    customer_service = Role.find_by(name: "customer_service")
    SubRole.create :name => "community", :role => customer_service
    SubRole.create :name => "customer_success", :role => customer_service
    SubRole.create :name => "investor_relations", :role => customer_service
    SubRole.create :name => "support", :role => customer_service
    education = Role.find_by(name: "education")
    SubRole.create :name => "dean", :role => education
    SubRole.create :name => "principal", :role => education
    SubRole.create :name => "professor", :role => education
    SubRole.create :name => "teacher", :role => education
    engineering = Role.find_by(name: "engineering")
    SubRole.create :name => "data_science_engineer", :role => engineering
    SubRole.create :name => "devops_engineer", :role => engineering
    SubRole.create :name => "electrical_engineer", :role => engineering
    SubRole.create :name => "mechanical_engineer", :role => engineering
    SubRole.create :name => "network_engineer", :role => engineering
    SubRole.create :name => "project_engineer", :role => engineering
    SubRole.create :name => "qa_engineer", :role => engineering
    SubRole.create :name => "software_engineer", :role => engineering
    SubRole.create :name => "systems_engineer", :role => engineering
    SubRole.create :name => "web_engineer", :role => engineering
    finance = Role.find_by(name: "finance")
    SubRole.create :name => "finance", :role => finance
    SubRole.create :name => "accounting", :role => finance
    SubRole.create :name => "investment", :role => finance
    SubRole.create :name => "tax_audit", :role => finance
    health_professional = Role.find_by(name: "health_professional")
    SubRole.create :name => "fitness", :role => health_professional
    SubRole.create :name => "medical_doctor", :role => health_professional
    SubRole.create :name => "nurse", :role => health_professional
    SubRole.create :name => "therapist", :role => health_professional
    human_resources = Role.find_by(name: "human_resources")
    SubRole.create :name => "benefits", :role => human_resources
    SubRole.create :name => "people_culture", :role => human_resources
    SubRole.create :name => "training", :role => human_resources
    information_technology = Role.find_by(name: "information_technology")
    SubRole.create :name => "architect_it", :role => information_technology
    SubRole.create :name => "business_intelligence_it", :role => information_technology
    SubRole.create :name => "data_it", :role => information_technology
    SubRole.create :name => "database_it", :role => information_technology
    SubRole.create :name => "qa_it", :role => information_technology
    SubRole.create :name => "security_it", :role => information_technology
    SubRole.create :name => "systems_it", :role => information_technology
    leadership = Role.find_by(name: "leadership")
    SubRole.create :name => "ceo", :role => leadership
    SubRole.create :name => "founder", :role => leadership
    SubRole.create :name => "owner", :role => leadership
    SubRole.create :name => "president", :role => leadership
    legal = Role.find_by(name: "legal")
    SubRole.create :name => "attorney", :role => legal
    SubRole.create :name => "contracts", :role => legal
    SubRole.create :name => "general_counsel", :role => legal
    SubRole.create :name => "paralegal", :role => legal
    SubRole.create :name => "regulatory", :role => legal
    marketing = Role.find_by(name: "marketing")
    SubRole.create :name => "brand_marketing", :role => marketing
    SubRole.create :name => "channel_marketing", :role => marketing
    SubRole.create :name => "content_marketing", :role => marketing
    SubRole.create :name => "copywriting", :role => marketing
    SubRole.create :name => "digital_marketing", :role => marketing
    SubRole.create :name => "field_marketing", :role => marketing
    SubRole.create :name => "product_marketing", :role => marketing
    SubRole.create :name => "social_marketing", :role => marketing
    operations = Role.find_by(name: "operations")
    SubRole.create :name => "assistant", :role => operations
    SubRole.create :name => "business_analyst", :role => operations
    SubRole.create :name => "facilities", :role => operations
    SubRole.create :name => "office_management", :role => operations
    SubRole.create :name => "project_management", :role => operations
    SubRole.create :name => "risk_compliance", :role => operations
    SubRole.create :name => "strategy", :role => operations
    product = Role.find_by(name: "product")
    SubRole.create :name => "creative", :role => product
    SubRole.create :name => "graphic_design", :role => product
    SubRole.create :name => "product_design", :role => product
    SubRole.create :name => "product_manager", :role => product
    public_relations = Role.find_by(name: "public_relations")
    SubRole.create :name => "events", :role => public_relations
    SubRole.create :name => "media_relations", :role => public_relations
    SubRole.create :name => "publicist", :role => public_relations
    real_estate = Role.find_by(name: "real_estate")
    SubRole.create :name => "appraisal", :role => real_estate
    SubRole.create :name => "property_manager", :role => real_estate
    SubRole.create :name => "realtor", :role => real_estate
    recruiting = Role.find_by(name: "recruiting")
    SubRole.create :name => "staffing", :role => recruiting
    SubRole.create :name => "talent", :role => recruiting
    sales = Role.find_by(name: "sales")
    SubRole.create :name => "account_executive", :role => sales
    SubRole.create :name => "business_development", :role => sales

  end
end
