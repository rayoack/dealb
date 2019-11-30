describe Investors::Searcher do
  subject { described_class.new(filter_params, matching_investor.domain_country_context) }

  context 'filters by status' do
    let!(:matching_investor) { create(:investor, status: Investor::ACTIVE) }
    let!(:_non_matching_investor) { create(:investor, status: Investor::INACTIVE) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'status',
            operator: 'equal',
            value: matching_investor.status
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_investor.id]) }
  end

  context 'filters by tag' do
    let!(:matching_investor) { create(:investor, tag: Investor::ANGEL) }
    let!(:_non_matching_investor) { create(:investor, tag: Investor::ACCELERATOR) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'tag',
            operator: 'equal',
            value: matching_investor.tag
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_investor.id]) }
  end

  context 'filters by funding stage' do
    let!(:matching_investor) { create(:investor, stage: Investor::SEED) }
    let!(:_non_matching_investor) { create(:investor, stage: Investor::IPO) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'stage',
            operator: 'equal',
            value: matching_investor.stage
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_investor.id]) }
  end

  context 'filters by number of deals' do
    let!(:matching_investor) { create(:investor) }
    let!(:non_matching_investor) { create(:investor) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'number_of_deals',
            operator: 'equal',
            value: '2'
          }
        }
      }.deep_stringify_keys
    end

    before do
      create_list(:deal_investor, 2, investor: matching_investor)
      create_list(:deal_investor, 1, investor: non_matching_investor)
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_investor.id]) }
  end

  context 'filters by total funds invested' do
    let!(:deal_1) { create :deal, amount: 200_000 }
    let!(:deal_2) { create :deal, amount: 2_000_000 }
    let!(:deal_3) { create :deal, amount: 800_000 }

    let!(:matching_investor) { create(:investor) }
    let!(:non_matching_investor) { create(:investor) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'total_funds_invested',
            operator: 'equal',
            value: ((deal_1.amount + deal_2.amount).to_i).to_s
          }
        }
      }.deep_stringify_keys
    end

    before do
      create :deal_investor, deal: deal_1, investor: matching_investor
      create :deal_investor, deal: deal_2, investor: matching_investor
      create :deal_investor, deal: deal_3, investor: non_matching_investor
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_investor.id]) }
  end

  context 'filters by multiple criteria' do
    let!(:matching_investor) do
      create :investor, status: Investor::ACTIVE,
                        tag: Investor::ANGEL,
                        stage: Investor::SEED
    end

    let!(:matching_investor2) do
      create :investor, status: Investor::ACTIVE,
                        tag: Investor::ANGEL,
                        stage: Investor::SEED
    end

    let!(:_non_matching_investor1) do
      create :investor, status: Investor::INACTIVE,
                        tag: Investor::ANGEL,
                        stage: Investor::SEED
    end

    let!(:_non_matching_investor2) do
      create :investor, status: Investor::ACTIVE,
                        tag: Investor::ACCELERATOR,
                        stage: Investor::SEED
    end

    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'status',
            operator: 'equal',
            value: Investor::ACTIVE
          },
          '1' => {
            type: 'tag',
            operator: 'contains',
            value: Investor::ANGEL
          },
          '2' => {
            type: 'stage',
            operator: 'contains',
            value: Investor::SEED
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to match_array([matching_investor.id, matching_investor2.id]) }
  end

  context 'sorting' do
    subject { described_class.new(filter_params, company_1.domain_country_context) }

    let!(:company_1) { create :company, name: 'Bossa', description: 'Only devops' }

    let!(:investor_1) { create :investor }
    let!(:investor_2) { create :investor }

    let(:deal_1) { create :deal }
    let(:deal_2) { create :deal }
    let(:deal_3) { create :deal }

    let(:filter_params) { {} }

    context 'order by deals count' do
      before do
        create :deal_investor, deal: deal_1, investor: investor_1

        create :deal_investor, deal: deal_2, investor: investor_2
        create :deal_investor, deal: deal_3, investor: investor_2
      end

      context 'ASC' do
        let(:filter_params) { { type: 'number_of_deals', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([investor_1, investor_2]) }
      end

      context 'DESC' do
        let(:filter_params) { { type: 'number_of_deals', order: 'desc' } }

        it { expect(subject.call.to_a).to match_array([investor_2, investor_1]) }
      end
    end
  end
end
