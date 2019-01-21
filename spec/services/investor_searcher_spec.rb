describe InvestorSearcher do
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

  it 'filters by category' do
    matching_investor = create(:investor, category: Investor::ANGEL)
    _non_matching_investor = create(:investor, category: Investor::ACCELERATOR)
    filter_params = {
      '0' => {
        'type' => 'category',
        'operator' => 'equal',
        'value' => matching_investor.category
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

  it 'filters by multiple criteria' do
    matching_investor1 = create(
      :investor,
      status: Investor::ACTIVE,
      category: Investor::ANGEL,
      stage: Investor::SEED
    )
    matching_investor2 = create(
      :investor,
      status: Investor::ACTIVE,
      category: Investor::ANGEL,
      stage: Investor::SEED
    )
    _non_matching_investor1 = create(
      :investor,
      status: Investor::INACTIVE,
      category: Investor::ANGEL,
      stage: Investor::SEED
    )
    _non_matching_investor2 = create(
      :investor,
      status: Investor::ACTIVE,
      category: Investor::ACCELERATOR,
      stage: Investor::SEED
    )
    filter_params = {
      '0' => {
        'type' => 'status',
        'operator' => 'equal',
        'value' => Investor::ACTIVE
      },
      '1' => {
        'type' => 'category',
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
end
