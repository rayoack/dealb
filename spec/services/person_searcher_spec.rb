describe PersonSearcher do
  it 'filters by first name' do
    matching_person = create(:person)
    _non_matching_person = create(:person)
    filter_params = {
      '0' => {
        'type' => 'name',
        'operator' => 'equal',
        'value' => matching_person.first_name
      }
    }

    result = described_class.new(
      filter_params,
      matching_person.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_person.id])
  end

  it 'filters by last name' do
    matching_person = create(:person)
    _non_matching_person = create(:person)
    filter_params = {
      '0' => {
        'type' => 'name',
        'operator' => 'equal',
        'value' => matching_person.last_name
      }
    }

    result = described_class.new(
      filter_params,
      matching_person.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_person.id])
  end

  it 'filters by full name' do
    matching_person = create(:person)
    _non_matching_person = create(:person)
    filter_params = {
      '0' => {
        'type' => 'name',
        'operator' => 'equal',
        'value' => [
          matching_person.first_name,
          matching_person.last_name
        ].join(' ')
      }
    }

    result = described_class.new(
      filter_params,
      matching_person.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_person.id])
  end

  it 'filters by description' do
    matching_person = create(:person, bio: 'first')
    _non_matching_person = create(:person, bio: 'second')
    filter_params = {
      '0' => {
        'type' => 'bio',
        'operator' => 'contains',
        'value' => matching_person.description
      }
    }

    result = described_class.new(
      filter_params,
      matching_person.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_person.id])
  end

  it 'filters by gender' do
    matching_person = create(:person, gender: Person::MALE)
    _non_matching_person = create(:person, gender: Person::FEMALE)
    filter_params = {
      '0' => {
        'type' => 'gender',
        'operator' => 'equal',
        'value' => matching_person.gender
      }
    }

    result = described_class.new(
      filter_params,
      matching_person.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_person.id])
  end

  it 'filters by occupation' do
    matching_person = create(:person)
    _non_matching_person = create(:person)
    filter_params = {
      '0' => {
        'type' => 'occupation',
        'operator' => 'equal',
        'value' => matching_person.occupation
      }
    }

    result = described_class.new(
      filter_params,
      matching_person.domain_country_context
    ).call

    expect(result.pluck(:id)).to eq([matching_person.id])
  end

  it 'filters by multiple criteria' do
    matching_person1 = create(
      :person,
      first_name: 'Fernando',
      last_name: 'Almeida',
      gender: Person::MALE
    )
    matching_person2 = create(
      :person,
      first_name: 'Fabio',
      last_name: 'Almeida',
      gender: Person::MALE
    )
    _non_matching_person1 = create(
      :person,
      first_name: 'Ana Sofia',
      last_name: 'Almeida',
      gender: Person::FEMALE
    )
    _non_matching_person2 = create(
      :person,
      first_name: 'Denise',
      last_name: 'Cerqueira',
      gender: Person::FEMALE
    )
    filter_params = {
      '0' => {
        'type' => 'gender',
        'operator' => 'equal',
        'value' => Person::MALE
      },
      '1' => {
        'type' => 'name',
        'operator' => 'contains',
        'value' => 'Almeida'
      }
    }

    result = described_class.new(
      filter_params,
      matching_person1.domain_country_context
    ).call

    expect(result.pluck(:id)).to match_array(
      [matching_person1.id, matching_person2.id]
    )
  end
end
