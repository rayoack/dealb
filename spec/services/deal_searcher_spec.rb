describe DealSearcher do
  subject { described_class.new(filter_params, matching_deal.domain_country_context) }

  context 'by status' do
    let!(:matching_deal) { create(:deal, status: Deal::VERIFIED) }
    let!(:non_matching_deal) { create(:deal, status: Deal::UNVERIFIED) }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'status',
            operator: 'equal',
            value: matching_deal.status
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal.id]) }
  end

  context 'by category' do
    let!(:matching_deal) { create(:deal, category: Deal::INCUBATED_BY) }
    let!(:non_matching_deal) { create(:deal, category: Deal::SHUTDOWN) }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'category',
            operator: 'contains',
            value: 'incubated'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal.id]) }
  end

  context 'by round' do
    let!(:matching_deal) { create(:deal, round: Deal::ACCELERATION) }
    let!(:non_matching_deal) { create(:deal, round: Deal::SERIES_A) }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'funding_type',
            operator: 'equal',
            value: matching_deal.round
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal.id]) }
  end

  context 'by amount' do
    let!(:matching_deal) { create(:deal, amount: '100_000_00'.to_i) }
    let!(:non_matching_deal) { create(:deal, amount: '1_000_000_00'.to_i) }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'amount',
            operator: 'equal',
            value: (matching_deal.amount.to_f).to_s
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal.id]) }
  end

  context 'by date' do
    let!(:matching_deal) { create(:deal, close_date: '2019-01-01') }
    let!(:non_matching_deal) { create(:deal, close_date: '2019-01-02') }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'date',
            operator: 'equal',
            value: matching_deal.close_date.to_s(:db)
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal.id]) }
  end

  context 'by partial date' do
    let!(:matching_deal) { create(:deal, close_date: '2019-01-01') }
    let!(:non_matching_deal) { create(:deal, close_date: '2018-01-01') }

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'date',
            operator: 'contains',
            value: '2019-01'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal.id]) }
  end

  context 'filters by multiple criteria' do
    let!(:matching_deal) do
      create :deal, status: Deal::VERIFIED,
                    category: Deal::INCUBATED_BY,
                    round: Deal::ACCELERATION,
                    close_date: 1.day.ago
    end

    let!(:matching_deal2) do
      create :deal, status: Deal::VERIFIED,
                    category: Deal::INCUBATED_BY,
                    round: Deal::ACCELERATION,
                    close_date: 1.hour.ago
    end

    let!(:non_matching_deal1) do
      create :deal, status: Deal::VERIFIED,
                    category: Deal::INCUBATED_BY,
                    round: Deal::SERIES_A
    end

    let!(:non_matching_deal2) do
      create :deal, status: Deal::VERIFIED,
                    category: Deal::SHUTDOWN,
                    round: Deal::SERIES_B
    end

    let(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'status',
            operator: 'equal',
            value: Deal::VERIFIED
          },
          '1' => {
            type: 'category',
            operator: 'equal',
            value: Deal::INCUBATED_BY
          },
          '2' => {
            type: 'funding_type',
            operator: 'equal',
            value: Deal::ACCELERATION
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_deal2.id, matching_deal.id]) }
  end

  context 'sorting' do
    subject { described_class.new(filter_params, company_1.domain_country_context) }

    let!(:company_1) { create :company, name: 'Bossa', description: 'Only devops' }
    let!(:company_2) { create :company, name: 'Box', description: 'For UXes' }
    let!(:deal_1) { create :deal, company: company_1, amount: 4000, close_date: 2.days.ago }
    let!(:deal_2) { create :deal, company: company_2, amount: 200, close_date: 1.hour.ago }
    let(:filter_params) { {} }

    context 'order by desc' do
      context 'name' do
        let(:filter_params) { { type: 'name', order: 'desc' } }

        it { expect(subject.call.to_a).to match_array([deal_2, deal_1]) }
      end

      context 'close_date' do
        let(:filter_params) { { type: 'close_date', order: 'desc' } }

        it { expect(subject.call.to_a).to match_array([deal_2, deal_1]) }
      end

      context 'amount' do
        let(:filter_params) { { type: 'amount', order: 'desc' } }

        it { expect(subject.call.to_a).to match_array([deal_1, deal_2]) }
      end
    end

    context 'order by asc' do
      context 'name' do
        let(:filter_params) { { type: 'name', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([deal_1, deal_2]) }
      end

      context 'close_date' do
        let(:filter_params) { { type: 'close_date', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([deal_1, deal_2]) }
      end

      context 'amount' do
        let(:filter_params) { { type: 'amount', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([deal_2, deal_1]) }
      end
    end
  end
end
