# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200212032120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "business_type_classifications", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_business_type_classifications_on_name"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "permalink", null: false
    t.text "description"
    t.integer "employees_count"
    t.date "founded_on"
    t.string "phone_number"
    t.string "contact_email"
    t.string "homepage_url"
    t.string "linkedin_url"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "google_plus_url"
    t.string "status", default: "active", null: false
    t.string "domain_country_context", default: "br", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "profile_image_url"
    t.string "legal_name"
    t.string "crunchbase_url"
    t.string "stock_symbol"
    t.string "stock_exchange"
    t.datetime "closed_on"
    t.integer "rank"
    t.datetime "clearbit_synchronized_at"
    t.index ["name"], name: "index_companies_on_name"
    t.index ["permalink"], name: "index_companies_on_permalink"
    t.index ["status"], name: "index_companies_on_status"
  end

  create_table "company_entity_sizes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_company_entity_sizes_on_name"
  end

  create_table "company_locations", id: :serial, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_markets", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "market_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_markets_on_company_id"
    t.index ["market_id"], name: "index_company_markets_on_market_id"
  end

  create_table "company_naics_codes", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_company_naics_codes_on_code"
  end

  create_table "company_sic_codes", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_company_sic_codes_on_code"
  end

  create_table "company_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_type_classifications", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_company_type_classifications_on_name"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deal_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_deal_categories_on_name"
  end

  create_table "deal_investors", force: :cascade do |t|
    t.bigint "deal_id", null: false
    t.bigint "investor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_deal_investors_on_deal_id"
    t.index ["investor_id"], name: "index_deal_investors_on_investor_id"
  end

  create_table "deal_rounds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deal_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deals", force: :cascade do |t|
    t.date "close_date", null: false
    t.bigint "company_id", null: false
    t.string "status", default: "unverified", null: false
    t.string "category", null: false
    t.string "round"
    t.string "amount_currency", default: "USD"
    t.bigint "amount_cents"
    t.string "pre_valuation_currency"
    t.bigint "pre_valuation_cents"
    t.string "source_url"
    t.string "domain_country_context", default: "br", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "amount"
    t.bigint "pre_valuation"
    t.decimal "exchange_rates", precision: 15, scale: 10
    t.bigint "amount_dolar"
    t.bigint "pre_valuation_dolar"
    t.index ["category"], name: "index_deals_on_category"
    t.index ["company_id"], name: "index_deals_on_company_id"
    t.index ["round"], name: "index_deals_on_round"
    t.index ["status"], name: "index_deals_on_status"
    t.index ["user_id"], name: "index_deals_on_user_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "industry_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_group_id"], name: "index_industries_on_industry_group_id"
    t.index ["name"], name: "index_industries_on_name"
  end

  create_table "industry_groups", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_industry_groups_on_name"
    t.index ["sector_id"], name: "index_industry_groups_on_sector_id"
  end

  create_table "investor_stages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investor_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investor_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investors", force: :cascade do |t|
    t.string "investable_type", null: false
    t.bigint "investable_id", null: false
    t.string "status", default: "active", null: false
    t.string "tag"
    t.string "stage"
    t.string "domain_country_context", default: "br", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investable_type", "investable_id"], name: "index_investors_on_investable_type_and_investable_id"
    t.index ["status"], name: "index_investors_on_status"
  end

  create_table "localizables", force: :cascade do |t|
    t.string "localizable_type", null: false
    t.bigint "localizable_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["localizable_type", "localizable_id"], name: "index_localizables_on_localizable_type_and_localizable_id"
    t.index ["location_id"], name: "index_localizables_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "country", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.index ["city"], name: "index_locations_on_city"
    t.index ["country"], name: "index_locations_on_country"
  end

  create_table "markets", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_markets_on_name"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "permalink", null: false
    t.text "bio"
    t.date "born_on"
    t.string "gender"
    t.string "phone_number"
    t.string "occupation"
    t.string "email"
    t.string "website_url"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "google_plus_url"
    t.string "linkedin_url"
    t.string "domain_country_context", default: "br", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "profile_image_url"
    t.datetime "clearbit_synchronized_at"
    t.integer "rank"
    t.datetime "died_on"
    t.datetime "verified_at"
    t.index ["first_name"], name: "index_people_on_first_name"
    t.index ["permalink"], name: "index_people_on_permalink"
  end

  create_table "person_companies", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "company_id", null: false
    t.date "started_at"
    t.date "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_title"
    t.index ["company_id"], name: "index_person_companies_on_company_id"
    t.index ["person_id"], name: "index_person_companies_on_person_id"
  end

  create_table "person_locations", id: :serial, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_seniorities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_person_seniorities_on_name"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name"
  end

  create_table "sub_industries", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "industry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_sub_industries_on_industry_id"
    t.index ["name"], name: "index_sub_industries_on_name"
  end

  create_table "sub_roles", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sub_roles_on_name"
    t.index ["role_id"], name: "index_sub_roles_on_role_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_tags_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.string "role", default: "user", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.bigint "person_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "deals", "users"
  add_foreign_key "industries", "industry_groups"
  add_foreign_key "industry_groups", "sectors"
  add_foreign_key "sub_industries", "industries"
  add_foreign_key "sub_roles", "roles"
  add_foreign_key "users", "people"
end
