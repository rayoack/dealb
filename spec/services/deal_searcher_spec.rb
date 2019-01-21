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
        'value' => matching_deal.amount_cents.to_s
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
end
