describe Investors::Ranking do
  subject { described_class.new(options) }

  let(:options) { {} }

  let(:deal_1) { create :deal, first_name: 'A' }
  let(:deal_2) { create :deal, first_name: 'B' }
  let(:deal_3) { create :deal, first_name: 'C' }
  let(:deal_4) { create :deal, first_name: 'D' }

  let!(:investor_1) { create :investor, investable: person_1 }
  let!(:investor_2) { create :investor, investable: person_2 }
  let!(:investor_3) { create :investor, investable: person_3 }
  let!(:investor_4) { create :investor, investable: person_4 }

  context 'success' do
    before do
      create :deal_investors, investor: investor_1,
                              deal: create(:deal, amount_cents: 100)

      create :deal_investors, investor: investor_2,
                              deal: create(:deal, amount_cents: 200)

      create :deal_investors, investor: investor_3,
                              deal: create(:deal, amount_cents: 300)

      create :deal_investors, investor: investor_4,
                              deal: create(:deal, amount_cents: 400)
    end

    context 'without order priority' do
      it '#call!' do
        expect(subject.call!).to eq(
          [
            investor_1,
            investor_2,
            investor_3,
            investor_4
          ]
        )
      end
    end

    context 'order by name'
    context 'order by deals'
    context 'order by capital'
    context 'order by location'
  end
end
