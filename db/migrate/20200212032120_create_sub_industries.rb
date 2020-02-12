class CreateSubIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_industries do |t|
      t.string :name, null: false, index: true
      t.belongs_to :industry, foreign_key: true

      t.timestamps
    end

    # Importar dados em massa
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Automobiles & Components", :sector => sector
    industry = Industry.find_or_create_by :name => "Automotive", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Automotive", :industry => industry
    
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Discretionary", :sector => sector
    industry = Industry.find_or_create_by :name => "Consumer Discretionary", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Consumer Discretionary", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Consumer Goods", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Consumer Goods", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Household Durables", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Consumer Electronics", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Household Durables", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Household Appliances", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Household Durables", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Photography", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Leisure Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Leisure Facilities", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Leisure Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Sporting Goods", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Textiles, Apparel & Luxury Goods", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Apparel, Accessories & Luxury Goods", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Textiles, Apparel & Luxury Goods", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Textiles", :industry => industry
    
    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Durables & Apparel", :sector => sector
    industry = Industry.find_or_create_by :name => "Textiles, Apparel & Luxury Goods", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Textiles, Apparel & Luxury Goods", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Consumer Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Consumer Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Consumer Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Education Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Consumer Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Specialized Consumer Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Hotels, Restaurants & Leisure", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Casinos & Gaming", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Hotels, Restaurants & Leisure", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Hotels, Restaurants & Leisure", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Hotels, Restaurants & Leisure", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Leisure Facilities", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Hotels, Restaurants & Leisure", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Restaurants", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Education Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Education", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Family Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Family Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Consumer Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Specialized Consumer Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Legal Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Media", :sector => sector
    industry = Industry.find_or_create_by :name => "Media", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Advertising", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Media", :sector => sector
    industry = Industry.find_or_create_by :name => "Media", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Broadcasting", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Media", :sector => sector
    industry = Industry.find_or_create_by :name => "Media", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Media", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Media", :sector => sector
    industry = Industry.find_or_create_by :name => "Media", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Movies & Entertainment", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Media", :sector => sector
    industry = Industry.find_or_create_by :name => "Media", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Public Relations", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Media", :sector => sector
    industry = Industry.find_or_create_by :name => "Media", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Publishing", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Retailing", :sector => sector
    industry = Industry.find_or_create_by :name => "Distributors", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Distributors", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Retailing", :sector => sector
    industry = Industry.find_or_create_by :name => "Retailing", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Retailing", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Retailing", :sector => sector
    industry = Industry.find_or_create_by :name => "Specialty Retail", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Home Improvement Retail", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Retailing", :sector => sector
    industry = Industry.find_or_create_by :name => "Specialty Retail", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Homefurnishing Retail", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Discretionary"
    industry_group = IndustryGroup.find_or_create_by :name => "Retailing", :sector => sector
    industry = Industry.find_or_create_by :name => "Specialty Retail", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Specialty Retail", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Consumer Staples", :sector => sector
    industry = Industry.find_or_create_by :name => "Consumer Staples", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Consumer Staples", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food & Staples Retailing", :sector => sector
    industry = Industry.find_or_create_by :name => "Food & Staples Retailing", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Food Retail", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food, Beverage & Tobacco", :sector => sector
    industry = Industry.find_or_create_by :name => "Beverages", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Beverages", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food, Beverage & Tobacco", :sector => sector
    industry = Industry.find_or_create_by :name => "Food Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Agricultural Products", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food, Beverage & Tobacco", :sector => sector
    industry = Industry.find_or_create_by :name => "Food Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Food", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food, Beverage & Tobacco", :sector => sector
    industry = Industry.find_or_create_by :name => "Food Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Food Production", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food, Beverage & Tobacco", :sector => sector
    industry = Industry.find_or_create_by :name => "Food Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Packaged Foods & Meats", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Food, Beverage & Tobacco", :sector => sector
    industry = Industry.find_or_create_by :name => "Tobacco", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Tobacco", :industry => industry

    sector = Sector.find_or_create_by :name => "Consumer Staples"
    industry_group = IndustryGroup.find_or_create_by :name => "Household & Personal Products", :sector => sector
    industry = Industry.find_or_create_by :name => "Personal Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Cosmetics", :industry => industry

    sector = Sector.find_or_create_by :name => "Energy"
    industry_group = IndustryGroup.find_or_create_by :name => "Energy Equipment & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Gas Utilities", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Oil & Gas", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Banks", :sector => sector
    industry = Industry.find_or_create_by :name => "Banks", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Banking & Mortgages", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financial Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Financial Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Accounting", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financial Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Financial Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Finance", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financial Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Financial Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Financial Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financials", :sector => sector
    industry = Industry.find_or_create_by :name => "Capital Markets", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Asset Management & Custody Banks", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financials", :sector => sector
    industry = Industry.find_or_create_by :name => "Capital Markets", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Diversified Capital Markets", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financials", :sector => sector
    industry = Industry.find_or_create_by :name => "Capital Markets", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Fundraising", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financials", :sector => sector
    industry = Industry.find_or_create_by :name => "Capital Markets", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Investment Banking & Brokerage", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Diversified Financials", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Financial Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Payments", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Insurance", :sector => sector
    industry = Industry.find_or_create_by :name => "Insurance", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Insurance", :industry => industry

    sector = Sector.find_or_create_by :name => "Financials"
    industry_group = IndustryGroup.find_or_create_by :name => "Real Estate", :sector => sector
    industry = Industry.find_or_create_by :name => "Real Estate", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Real Estate", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Health Care Equipment & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Health Care Equipment & Supplies", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Eyewear", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Health Care Equipment & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Health Care Providers & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Health & Wellness", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Health Care Equipment & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Health Care Providers & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Health Care", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Health Care Equipment & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Health Care Providers & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Health Care Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Pharmaceuticals, Biotechnology & Life Sciences", :sector => sector
    industry = Industry.find_or_create_by :name => "Biotechnology", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Biotechnology", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Pharmaceuticals, Biotechnology & Life Sciences", :sector => sector
    industry = Industry.find_or_create_by :name => "Life Sciences Tools & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Life Sciences Tools & Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Health Care"
    industry_group = IndustryGroup.find_or_create_by :name => "Pharmaceuticals, Biotechnology & Life Sciences", :sector => sector
    industry = Industry.find_or_create_by :name => "Pharmaceuticals", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Pharmaceuticals", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Aerospace & Defense", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Aerospace & Defense", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Capital Goods", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Capital Goods", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Commercial Services & Supplies", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Commercial Printing", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Construction & Engineering", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Civil Engineering", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Construction & Engineering", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Construction", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Construction & Engineering", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Construction & Engineering", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Construction & Engineering", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Mechanical Engineering", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Electrical Equipment", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Electrical", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Electrical Equipment", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Electrical Equipment", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Industrial Conglomerates", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Industrials & Manufacturing", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Machinery", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Industrial Machinery", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Machinery", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Machinery", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Capital Goods", :sector => sector
    industry = Industry.find_or_create_by :name => "Trading Companies & Distributors", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Trading Companies & Distributors", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Commercial Services & Supplies", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Business Supplies", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Commercial Services & Supplies", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Commercial Printing", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Commercial Services & Supplies", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Corporate & Business", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Architecture", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Automation", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Consulting", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Design", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Human Resource & Employment Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Professional Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Commercial & Professional Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Professional Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Research & Consulting Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Industrials", :sector => sector
    industry = Industry.find_or_create_by :name => "Industrials", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Industrials", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Transportation", :sector => sector
    industry = Industry.find_or_create_by :name => "Air Freight & Logistics", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Shipping & Logistics", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Transportation", :sector => sector
    industry = Industry.find_or_create_by :name => "Airlines", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Airlines", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Transportation", :sector => sector
    industry = Industry.find_or_create_by :name => "Marine", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Marine", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Transportation", :sector => sector
    industry = Industry.find_or_create_by :name => "Road & Rail", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Ground Transportation", :industry => industry

    sector = Sector.find_or_create_by :name => "Industrials"
    industry_group = IndustryGroup.find_or_create_by :name => "Transportation", :sector => sector
    industry = Industry.find_or_create_by :name => "Transportation", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Transportation", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Semiconductors & Semiconductor Equipment", :sector => sector
    industry = Industry.find_or_create_by :name => "Semiconductors & Semiconductor Equipment", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Semiconductors", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Software & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Internet Software & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Cloud Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Software & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Internet Software & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Internet", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Software & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Internet Software & Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Internet Software & Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Software & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "IT Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Data Processing & Outsourced Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Software & Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Software", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Graphic Design", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Technology Hardware & Equipment", :sector => sector
    industry = Industry.find_or_create_by :name => "Communications Equipment", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Communications", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Technology Hardware & Equipment", :sector => sector
    industry = Industry.find_or_create_by :name => "Communications Equipment", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Computer Networking", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Technology Hardware & Equipment", :sector => sector
    industry = Industry.find_or_create_by :name => "Electronic Equipment, Instruments & Components", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Nanotechnology", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Technology Hardware & Equipment", :sector => sector
    industry = Industry.find_or_create_by :name => "Technology Hardware, Storage & Peripherals", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Computer Hardware", :industry => industry

    sector = Sector.find_or_create_by :name => "Information Technology"
    industry_group = IndustryGroup.find_or_create_by :name => "Technology Hardware & Equipment", :sector => sector
    industry = Industry.find_or_create_by :name => "Technology Hardware, Storage & Peripherals", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Technology Hardware, Storage & Peripherals", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Construction Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Building Materials", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Building Materials", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Chemicals", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Chemicals", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Chemicals", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Commodity Chemicals", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Containers & Packaging", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Containers & Packaging", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Metals & Mining", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Gold", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Metals & Mining", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Metals & Mining", :industry => industry

    sector = Sector.find_or_create_by :name => "Materials"
    industry_group = IndustryGroup.find_or_create_by :name => "Materials", :sector => sector
    industry = Industry.find_or_create_by :name => "Paper & Forest Products", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Paper Products", :industry => industry

    sector = Sector.find_or_create_by :name => "Telecommunication Services"
    industry_group = IndustryGroup.find_or_create_by :name => "Telecommunication Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Diversified Telecommunication Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Integrated Telecommunication Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Telecommunication Services"
    industry_group = IndustryGroup.find_or_create_by :name => "Telecommunication Services", :sector => sector
    industry = Industry.find_or_create_by :name => "Wireless Telecommunication Services", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Wireless Telecommunication Services", :industry => industry

    sector = Sector.find_or_create_by :name => "Utilities"
    industry_group = IndustryGroup.find_or_create_by :name => "Independent Power and Renewable Electricity Producers", :sector => sector
    industry = Industry.find_or_create_by :name => "Renewable Electricity", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Renewable Energy", :industry => industry

    sector = Sector.find_or_create_by :name => "Utilities"
    industry_group = IndustryGroup.find_or_create_by :name => "Utilities", :sector => sector
    industry = Industry.find_or_create_by :name => "Electric Utilities", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Energy", :industry => industry

    sector = Sector.find_or_create_by :name => "Utilities"
    industry_group = IndustryGroup.find_or_create_by :name => "Utilities", :sector => sector
    industry = Industry.find_or_create_by :name => "Utilities", :industry_group => industry_group
    sub_industry = SubIndustry.create :name => "Utilities", :industry => industry

  end
end
