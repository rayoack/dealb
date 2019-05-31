describe PersonSearcher do
  subject { described_class.new(filter_params, matching_person.domain_country_context) }

  context 'filters by first name' do
    let!(:matching_person) { create(:person) }
    let!(:_non_matching_person) { create(:person) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'name',
            operator: 'equal',
            value: matching_person.first_name
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_person.id]) }
  end

  context 'filters by last name' do
    let!(:matching_person) { create(:person) }
    let!(:_non_matching_person) { create(:person) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'name',
            operator: 'equal',
            value: matching_person.last_name
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_person.id]) }
  end

  context 'filters by full name' do
    let!(:matching_person) { create(:person) }
    let!(:_non_matching_person) { create(:person) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'name',
            operator: 'equal',
            value: [
              matching_person.first_name,
              matching_person.last_name
            ].join(' ')
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_person.id]) }
  end

  context 'filters by description' do
    let!(:matching_person) { create(:person, bio: 'first') }
    let!(:_non_matching_person) { create(:person, bio: 'second') }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'bio',
            operator: 'contains',
            value: matching_person.description
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_person.id]) }
  end

  context 'filters by gender' do
    let!(:matching_person) { create(:person, gender: Person::MALE) }
    let!(:_non_matching_person) { create(:person, gender: Person::FEMALE) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'gender',
            operator: 'equal',
            value: matching_person.gender
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_person.id]) }
  end

  context 'filters by occupation' do
    let!(:matching_person) { create(:person) }
    let!(:_non_matching_person) { create(:person) }
    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'occupation',
            operator: 'equal',
            value: matching_person.occupation
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to eq([matching_person.id]) }
  end

  context 'filters by multiple criteria' do
    let!(:matching_person) do
      create :person, first_name: 'Fernando',
                      last_name: 'Almeida',
                      gender: Person::MALE
    end

    let!(:matching_person2) do
      create :person, first_name: 'Fabio',
                      last_name: 'Almeida',
                      gender: Person::MALE
    end

    let!(:_non_matching_person1) do
      create :person, first_name: 'Ana Sofia',
                      last_name: 'Almeida',
                      gender: Person::FEMALE
    end

    let!(:_non_matching_person2) do
      create :person, first_name: 'Denise',
                      last_name: 'Cerqueira',
                      gender: Person::FEMALE
    end

    let!(:filter_params) do
      {
        filter: {
          '0' => {
            type: 'gender',
            operator: 'equal',
            value: Person::MALE
          },
          '1' => {
            type: 'name',
            operator: 'contains',
            value: 'Almeida'
          }
        }
      }.deep_stringify_keys
    end

    it { expect(subject.call.pluck(:id)).to match_array([matching_person.id, matching_person2.id]) }
  end

  context 'sorting' do
    subject { described_class.new(filter_params, company.domain_country_context) }

    let(:company) { create :company }
    let!(:person_1) { create :person, first_name: 'Lucas', occupation: 'PM' }
    let!(:person_2) { create :person, first_name: 'Pedro', occupation: 'DevOps' }
    let(:filter_params) { {} }

    context 'order by desc' do
      context 'name' do
        let(:filter_params) { { type: 'first_name', order: 'desc' } }

        it { expect(subject.call.to_a).to match_array([person_2, person_1]) }
      end

      context 'occupation' do
        let(:filter_params) { { type: 'occupation', order: 'desc' } }

        it { expect(subject.call.to_a).to match_array([person_1, person_2]) }
      end
    end

    context 'order by asc' do
      context 'name' do
        let(:filter_params) { { type: 'first_name', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([person_1, person_2]) }
      end

      context 'occupation' do
        let(:filter_params) { { type: 'occupation', order: 'asc' } }

        it { expect(subject.call.to_a).to match_array([person_2, person_1]) }
      end
    end
  end
end
