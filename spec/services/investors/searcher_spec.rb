describe Investors::Searcher do
  it 'filters by status' do
    matching_investor = create(:investor, status: Investor::ACTIVE)
    _non_matching_investor = create(:investor, status: Investor::INACTIVE)
    filter_params = {
      '0' => {
        'type' => 'status',
        'operator' => 'equal',
        'value' => matching_investor.status
      }
    }

    result = described_class.new(
      filter_params,
      matching_investor.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_investor.id])
  end

  it 'filters by tag' do
    matching_investor = create(:investor, tag: Investor::ANGEL)
    _non_matching_investor = create(:investor, tag: Investor::ACCELERATOR)
    filter_params = {
      '0' => {
        'type' => 'tag',
        'operator' => 'equal',
        'value' => matching_investor.tag
      }
    }

    result = described_class.new(
      filter_params,
      matching_investor.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_investor.id])
  end

  it 'filters by funding stage' do
    matching_investor = create(:investor, stage: Investor::SEED)
    _non_matching_investor = create(:investor, stage: Investor::IPO)
    filter_params = {
      '0' => {
        'type' => 'stage',
        'operator' => 'equal',
        'value' => matching_investor.stage
      }
    }

    result = described_class.new(
      filter_params,
      matching_investor.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_investor.id])
  end

  it 'filters by number of deals' do
    matching_investor = create(:investor)
    non_matching_investor = create(:investor)
    create_list(:deal_investor, 2, investor: matching_investor)
    create_list(:deal_investor, 1, investor: non_matching_investor)

    filter_params = {
      '0' => {
        'type' => 'number_of_deals',
        'operator' => 'equal',
        'value' => '2'
      }
    }

    result = described_class.new(
      filter_params,
      matching_investor.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_investor.id])
  end

  it 'filters by total funds invested' do
    matching_investor = create(:investor)
    non_matching_investor = create(:investor)
    deal_1 = create :deal, amount_cents: 200_000
    deal_2 = create :deal, amount_cents: 2_000_000
    deal_3 = create :deal, amount_cents: 800_000

    create :deal_investor, deal: deal_1, investor: matching_investor
    create :deal_investor, deal: deal_2, investor: matching_investor
    create :deal_investor, deal: deal_3, investor: non_matching_investor

    filter_params = {
      '0' => {
        'type' => 'total_funds_invested',
        'operator' => 'equal',
        'value' => ((deal_1.amount_cents + deal_2.amount_cents).to_i / 100).to_s
      }
    }

    result = described_class.new(
      filter_params,
      matching_investor.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_investor.id])
  end

  it 'filters by multiple criteria' do
    matching_investor1 = create(
      :investor,
      status: Investor::ACTIVE,
      tag: Investor::ANGEL,
      stage: Investor::SEED
    )
    matching_investor2 = create(
      :investor,
      status: Investor::ACTIVE,
      tag: Investor::ANGEL,
      stage: Investor::SEED
    )
    _non_matching_investor1 = create(
      :investor,
      status: Investor::INACTIVE,
      tag: Investor::ANGEL,
      stage: Investor::SEED
    )
    _non_matching_investor2 = create(
      :investor,
      status: Investor::ACTIVE,
      tag: Investor::ACCELERATOR,
      stage: Investor::SEED
    )
    filter_params = {
      '0' => {
        'type' => 'status',
        'operator' => 'equal',
        'value' => Investor::ACTIVE
      },
      '1' => {
        'type' => 'tag',
        'operator' => 'contains',
        'value' => Investor::ANGEL
      },
      '2' => {
        'type' => 'stage',
        'operator' => 'contains',
        'value' => Investor::SEED
      }
    }

    result = described_class.new(
      filter_params,
      matching_investor1.domain_country_context
    ).call

    expect(result.pluck(:id)).to match_array(
      [matching_investor1.id, matching_investor2.id]
    )
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
