describe DealSearcher do
  it 'filters by status' do
    matching_deal = create(:deal, status: Deal::VERIFIED)
    _non_matching_deal = create(:deal, status: Deal::UNVERIFIED)
    filter_params = {
      '0' => {
        'type' => 'status',
        'operator' => 'equal',
        'value' => matching_deal.status
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_deal.id])
  end

  it 'filters by category' do
    matching_deal = create(:deal, category: Deal::INCUBATED_BY)
    _non_matching_deal = create(:deal, category: Deal::SHUTDOWN)
    filter_params = {
      '0' => {
        'type' => 'category',
        'operator' => 'contains',
        'value' => 'incubated'
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_deal.id])
  end

  it 'filters by round' do
    matching_deal = create(:deal, round: Deal::ACCELERATION)
    _non_matching_deal = create(:deal, round: Deal::SERIES_A)
    filter_params = {
      '0' => {
        'type' => 'funding_type',
        'operator' => 'equal',
        'value' => matching_deal.round
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_deal.id])
  end

  it 'filters by amount' do
    matching_deal = create(:deal, amount_cents: '100_000_00'.to_i)
    _non_matching_deal = create(:deal, amount_cents: '1_000_000_00'.to_i)
    filter_params = {
      '0' => {
        'type' => 'amount',
        'operator' => 'equal',
        'value' => (matching_deal.amount_cents.to_f / 100).to_s
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_deal.id])
  end

  it 'filters by date' do
    matching_deal = create(:deal, close_date: '2019-01-01')
    _non_matching_deal = create(:deal, close_date: '2019-01-02')
    filter_params = {
      '0' => {
        'type' => 'date',
        'operator' => 'equal',
        'value' => matching_deal.close_date.to_s(:db)
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_deal.id])
  end

  it 'filters by partial date' do
    matching_deal = create(:deal, close_date: '2019-01-01')
    _non_matching_deal = create(:deal, close_date: '2018-01-01')
    filter_params = {
      '0' => {
        'type' => 'date',
        'operator' => 'contains',
        'value' => '2019-01'
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_deal.id])
  end

  it 'filters by multiple criteria' do
    matching_deal1 = create(
      :deal,
      status: Deal::VERIFIED,
      category: Deal::INCUBATED_BY,
      round: Deal::ACCELERATION
    )
    matching_deal2 = create(
      :deal,
      status: Deal::VERIFIED,
      category: Deal::INCUBATED_BY,
      round: Deal::ACCELERATION
    )
    _non_matching_deal1 = create(
      :deal,
      status: Deal::VERIFIED,
      category: Deal::INCUBATED_BY,
      round: Deal::SERIES_A
    )
    _non_matching_deal2 = create(
      :deal,
      status: Deal::VERIFIED,
      category: Deal::SHUTDOWN,
      round: Deal::SERIES_B
    )
    filter_params = {
      '0' => {
        'type' => 'status',
        'operator' => 'equal',
        'value' => Deal::VERIFIED
      },
      '1' => {
        'type' => 'category',
        'operator' => 'equal',
        'value' => Deal::INCUBATED_BY
      },
      '2' => {
        'type' => 'funding_type',
        'operator' => 'equal',
        'value' => Deal::ACCELERATION
      }
    }

    result = described_class.new(
      filter_params,
      matching_deal1.domain_country_context
    ).call

    expect(result.pluck(:id)).to match_array(
      [matching_deal1.id, matching_deal2.id]
    )
  end

  context 'sorting' do
    subject { described_class.new(filter_params, company_1.domain_country_context) }

    let!(:company_1) { create :company, name: 'Bossa', description: 'Only devops' }
    let!(:company_2) { create :company, name: 'Box', description: 'For UXes' }
    let!(:deal_1) { create :deal, company: company_1, amount_cents: 4000, close_date: 2.days.ago }
    let!(:deal_2) { create :deal, company: company_2, amount_cents: 200, close_date: 1.hour.ago }
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
        let(:filter_params) { { type: 'amount_cents', order: 'desc' } }

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
        let(:filter_params) { { type: 'amount_cents', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([deal_2, deal_1]) }
      end
    end
  end
end
