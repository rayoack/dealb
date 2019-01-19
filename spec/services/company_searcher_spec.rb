describe CompanySearcher do
  it 'filters by name' do
    matching_company = create(:company)
    _non_matching_company = create(:company)
    filter_params = {
      '0' => {
        'type' => 'name',
        'operator' => 'equal',
        'value' => matching_company.name
      }
    }

    result = described_class.new(
      filter_params,
      matching_company.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_company.id])
  end

  it 'filters by description' do
    matching_company = create(:company, description: "Pucca's Inc")
    _non_matching_company = create(:company)
    filter_params = {
      '0' => {
        'type' => 'description',
        'operator' => 'contains',
        'value' => 'pucca'
      }
    }

    result = described_class.new(
      filter_params,
      matching_company.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_company.id])
  end

  it 'filters by status' do
    matching_company = create(:company, status: :active)
    _non_matching_company = create(:company, status: :acquired)
    filter_params = {
      '0' => {
        'type' => 'status',
        'operator' => 'equal',
        'value' => 'active'
      }
    }

    result = described_class.new(
      filter_params,
      matching_company.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_company.id])
  end

  it 'filters by employees count' do
    matching_company = create(:company, employees_count: 100)
    _non_matching_company = create(:company, employees_count: 1_000)
    filter_params = {
      '0' => {
        'type' => 'employees_count',
        'operator' => 'equal',
        'value' => '100'
      }
    }

    result = described_class.new(
      filter_params,
      matching_company.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_company.id])
  end

  it 'filters by location city' do
    matching_location = create(:localizable)
    _non_matching_location = create(:localizable)
    filter_params = {
      '0' => {
        'type' => 'location',
        'operator' => 'equal',
        'value' => matching_location.location.city
      }
    }

    result = described_class.new(
      filter_params,
      matching_location.localizable.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_location.localizable.id])
  end

  it 'filters by location country' do
    matching_location = create(:localizable)
    _non_matching_location = create(:localizable)
    filter_params = {
      '0' => {
        'type' => 'location',
        'operator' => 'equal',
        'value' => matching_location.location.country
      }
    }

    result = described_class.new(
      filter_params,
      matching_location.localizable.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_location.localizable.id])
  end

  it 'filters by multiple filters' do
    matching_company_1 = create(
      :company,
      name: "Pucca's Inc",
      description: "Network infrastructure as a service."
    )
    matching_company_2 = create(
      :company,
      name: "Bahia's Inc",
      description: "The best company for deep learning and neural networks."
    )
    _non_matching_company_1 = create(
      :company,
      name: "Pucca's Corp",
      description: "Network provider",
      employees_count: 100,
      status: :active
    )
    _non_matching_company_2 = create(
      :company,
      name: "Bahia's Inc",
      description: "Artifial intelligence"
    )
    filter_params = {
      '0' => {
        'type' => 'name',
        'operator' => 'contains',
        'value' => 'inc'
      },
      '1' => {
        'type' => 'description',
        'operator' => 'contains',
        'value' => 'network'
      }
    }

    result = described_class.new(
      filter_params,
      matching_company_1.domain_country_context
    ).call

    expect(result.pluck(:id)).to match_array(
      [matching_company_1.id, matching_company_2.id]
    )
  end
end
