describe Companies::Searcher do
  subject { described_class.new(filter_params, matching_company.domain_country_context) }

  context 'filters by name' do
    let!(:matching_company) { create(:company) }
    let!(:non_matching_company) { create(:company) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'name',
            operator: 'equal',
            value: matching_company.name
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
  end

  context 'filters by description' do
    let!(:matching_company) { create(:company, description: "Pucca's Inc") }
    let!(:non_matching_company) { create(:company) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'description',
            operator: 'contains',
            value: 'pucca'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
  end

  context 'filters by status' do
    let!(:matching_company) { create(:company, status: :active) }
    let!(:non_matching_company) { create(:company, status: :acquired) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'status',
            operator: 'equal',
            value: 'active'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
  end

  context 'filters by employees count' do
    let!(:matching_company) { create(:company, employees_count: 100) }
    let!(:non_matching_company) { create(:company, employees_count: 1_000) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'employees_count',
            operator: 'equal',
            value: '100'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
  end

  context 'filters by location city' do
    subject { described_class.new(filter_params, matching_location.localizable.domain_country_context) }

    let!(:matching_location) { create(:localizable) }
    let!(:_non_matching_location) { create(:localizable) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'location',
            operator: 'equal',
            value: matching_location.location.city
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_location.localizable.id]) }
  end

  context 'filters by location country' do
    subject { described_class.new(filter_params, matching_location.localizable.domain_country_context) }

    let!(:matching_location) { create(:localizable) }
    let!(:_non_matching_location) { create(:localizable) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'location',
            operator: 'equal',
            value: matching_location.location.country
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_location.localizable.id]) }
  end

  context 'filters by multiple filters' do
    let!(:matching_company) do
      create :company, name: "Pucca's Inc",
                       description: 'Network infrastructure as a service.'
    end

    let!(:matching_company_2) do
      create :company, name: "Bahia's Inc",
                       description: 'The best company for deep learning and neural networks.'
    end

    let!(:non_matching_company_1) do
      create :company, name: "Pucca's Corp",
                       description: 'Network provider',
                       employees_count: 100,
                       status: :active
    end

    let!(:non_matching_company_2) do
      create :company, name: "Bahia's Inc", description: 'Artifial intelligence'
    end

    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'name',
            operator: 'contains',
            value: 'inc'
          },
          '1' => {
            type: 'description',
            operator: 'contains',
            value: 'network'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to match_array([matching_company.id, matching_company_2.id]) }
  end

  context 'filters by funds raised' do
    let!(:matching_company) { create :company }
    let!(:non_matching_company) { create :company }
    let(:operator) { 'equal' }
    let(:value) { 500 }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'funds_raised',
            operator: operator,
            value: value
          }
        }
      }.deep_stringify_keys
    end

    before do
      create :deal, company: matching_company, amount: 200
      create :deal, company: matching_company, amount: 300

      create :deal, company: non_matching_company, amount: 300
    end

    context 'with exact amount' do
      it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
    end

    context 'with greater than' do
      let(:operator) { 'greater_than' }
      let(:value) { 301 }

      it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
    end
  end

  context 'filters by tags' do
    let!(:matching_company) { create :company }
    let!(:non_matching_company) { create :company }
    let(:operator) { 'equal' }
    let(:value) { 'SAAS' }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'tag',
            operator: operator,
            value: value
          }
        }
      }.deep_stringify_keys
    end

    before do
      create :tag, company: matching_company, name: 'SAAS'
      create :tag, company: non_matching_company, name: 'NON_SAAS'
    end

    context 'with exact amount' do
      it { expect(subject.call.pluck(:id)).to eq([matching_company.id]) }
    end
  end

  context 'sorting' do
    subject { described_class.new(filter_params, company_1.domain_country_context) }

    let!(:company_1) { create :company, name: 'Bossa', description: 'Only devops' }
    let!(:company_2) { create :company, name: 'Box', description: 'For UXes' }
    let(:filter_params) { {} }

    context 'order by name desc' do
      let(:filter_params) { { type: 'name', order: 'desc' } }

      it { expect(subject.call.to_a).to match_array([company_2, company_1]) }
    end

    context 'order by name asc' do
      let(:filter_params) { { type: 'name', order: 'asc' } }

      it { expect(subject.call.to_a).to match_array([company_1, company_2]) }
    end
  end
end
