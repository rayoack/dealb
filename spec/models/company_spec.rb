# frozen_string_literal: true

describe Company do
  subject(:company) { build(:company) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }

    describe 'permalink' do
      it 'is a valid slug, then returns valid' do
        company.permalink = 'right-permalink'

        is_expected.to be_valid
      end

      it 'is not a valid permalink, then returns invalid' do
        company.name = nil
        company.permalink = 'wrong permalink'

        is_expected.not_to be_valid
        expect(company.errors[:permalink]).to eq(['is invalid'])
      end
    end

    it do
      is_expected.to(
        validate_inclusion_of(:status).in_array(described_class::STATUSES)
      )
    end

    it do
      is_expected.to validate_numericality_of(:employees_count).only_integer
    end

    describe 'founded_on' do
      it 'is a valid founded_on, then returns valid' do
        company.founded_on = Time.zone.today

        is_expected.to be_valid
      end

      it 'could be nil' do
        company.founded_on = nil

        is_expected.to be_valid
      end
    end

    describe 'contact_email' do
      it 'is a valid contact_email, then returns valid' do
        company.contact_email = 'myemail@gmail.com'

        is_expected.to be_valid
      end

      it 'is not a valid contact_email, then returns invalid' do
        company.contact_email = 'i-am-not-an-email'

        is_expected.to_not be_valid
      end

      it 'could be nil' do
        company.contact_email = nil

        is_expected.to be_valid
      end
    end

    describe 'homepage_url' do
      it 'is a valid homepage_url, then returns valid' do
        company.homepage_url = 'https://dealbook.com'

        is_expected.to be_valid
      end

      it 'is not a valid homepage_url, then returns invalid' do
        company.homepage_url = 'dealbook.xls'

        is_expected.to_not be_valid
      end

      it 'could be nil' do
        company.homepage_url = nil

        is_expected.to be_valid
      end
    end

    describe 'linkedin_url' do
      it 'is a valid linkedin_url, then returns valid' do
        company.linkedin_url = 'https://linkedin.com/dealbook'

        is_expected.to be_valid
      end

      it 'is not a valid linkedin_url, then returns invalid' do
        company.linkedin_url = 'linkedin@whatever.com'

        is_expected.to_not be_valid
      end

      it 'could be nil' do
        company.linkedin_url = nil

        is_expected.to be_valid
      end
    end

    describe 'facebook_url' do
      it 'is a valid facebook_url, then returns valid' do
        company.facebook_url = 'https://facebook.com/dealbook'

        is_expected.to be_valid
      end

      it 'is not a valid facebook_url, then returns invalid' do
        company.facebook_url = 'facebook@whatever.com'

        is_expected.to_not be_valid
      end

      it 'could be nil' do
        company.facebook_url = nil

        is_expected.to be_valid
      end
    end

    describe 'google_plus_url' do
      it 'is a valid google_plus_url, then returns valid' do
        company.google_plus_url = 'https://google_plus.com/dealbook'

        is_expected.to be_valid
      end

      it 'is not a valid google_plus_url, then returns invalid' do
        company.google_plus_url = 'google_plus@whatever.com'

        is_expected.to_not be_valid
      end

      it 'could be nil' do
        company.google_plus_url = nil

        is_expected.to be_valid
      end
    end

    describe 'twitter_url' do
      it 'is a valid twitter_url, then returns valid' do
        company.twitter_url = 'https://twitter.com/dealbook'

        is_expected.to be_valid
      end

      it 'is not a valid twitter_url, then returns invalid' do
        company.twitter_url = 'twitter@whatever.com'

        is_expected.to_not be_valid
      end

      it 'could be nil' do
        company.twitter_url = nil

        is_expected.to be_valid
      end
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:deals).dependent(:destroy) }

    it { is_expected.to have_many(:person_companies).dependent(:destroy) }

    it { is_expected.to have_many(:locations).through(:localizables) }

    it { is_expected.to have_many(:company_markets).dependent(:destroy) }

    it { is_expected.to have_many(:markets).through(:company_markets) }
  end
end
