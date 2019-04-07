describe GlobalSearcher do
  subject { described_class.new(term).call! }

  let(:term) { nil }

  context 'search by company' do
    let(:term) { 'search' }

    let!(:company) { create :company, name: 'MySearch' }
    let!(:other_company) { create :company, name: 'WeirdName' }

    it 'matches' do
      results = subject

      expect(results).to eq([company])
    end
  end

  context 'search by person' do
    let(:term) { 'romario' }

    let!(:with_first_name) { create :person, first_name: 'romario' }
    let!(:with_last_name) { create :person, last_name: 'de santos romario' }
    let!(:other_person) { create :person, first_name: 'ana', last_name: 'ana' }

    it 'matches' do
      results = subject

      expect(results).to eq([with_first_name, with_last_name])
    end
  end

  context 'search by investor' do
    let(:term) { 'anything' }

    context 'from companies' do
      let!(:company) { create :company, name: 'AnytHiNG' }
      let!(:investor) { create :investor, investable: company }
      let!(:other_company) { create :company, name: 'Redpoint Ventures' }
      let!(:other_investor) { create :investor, investable: other_company }

      it 'matches' do
        results = subject

        expect(results).to eq([company, investor])
      end
    end

    context 'from person' do
      let!(:person) { create :person, first_name: 'AnytHiNG' }
      let!(:investor) { create :investor, investable: person }
      let!(:person_last_name) { create :person, last_name: 'Anything' }
      let!(:second_investor) { create :investor, investable: person_last_name }
      let!(:any_person) { create :person, first_name: 'Jess', last_name: 'J' }
      let!(:any_investor) { create :investor, investable: any_person }

      it 'matches' do
        results = subject

        expect(results)
          .to eq([person, person_last_name, investor, second_investor])
      end
    end
  end

  context 'search by deals' do
    let(:term) { 'stone' }

    let!(:company) { create :company, name: 'Stone Payments' }
    let!(:deal) { create :deal, company: company }
    let!(:any_company) { create :company, name: 'Maçã Co.' }
    let!(:any_deal) { create :deal, company: any_company }

    it 'matches' do
      results = subject

      expect(results).to eq([company, deal])
    end
  end
end
