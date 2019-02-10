describe Investors::Ranking do
  subject { described_class.new(options) }

  let(:options) { {} }

  let(:person_1) { create :person, first_name: 'A' }
  let(:person_2) { create :person, first_name: 'B' }
  let(:person_3) { create :person, first_name: 'C' }
  let(:person_4) { create :person, first_name: 'D' }

  let!(:investor_1) { create :investor, investable: person_1 }
  let!(:investor_2) { create :investor, investable: person_2 }
  let!(:investor_3) { create :investor, investable: person_3 }
  let!(:investor_4) { create :investor, investable: person_4 }

  context 'success' do
    before do
      # First investor
      create :deal_investor, investor: investor_1,
                             deal: create(:deal, amount_cents: 100)

      # Second investor
      create :deal_investor, investor: investor_2,
                             deal: create(:deal, amount_cents: 200)
      create :deal_investor, investor: investor_2,
                             deal: create(:deal, amount_cents: 200)
      create :deal_investor, investor: investor_2,
                             deal: create(:deal, amount_cents: 200)

      # Third investor
      create :deal_investor, investor: investor_3,
                             deal: create(:deal, amount_cents: 300)
      create :deal_investor, investor: investor_3,
                             deal: create(:deal, amount_cents: 300)
      create :deal_investor, investor: investor_3,
                             deal: create(:deal, amount_cents: 300)
      create :deal_investor, investor: investor_3,
                             deal: create(:deal, amount_cents: 300)

      # Fourth investor
      create :deal_investor, investor: investor_4,
                             deal: create(:deal, amount_cents: 400)
      create :deal_investor, investor: investor_4,
                             deal: create(:deal, amount_cents: 400)
    end

    context 'without order priority' do
      it '#call!' do
        expect(subject.call!.map(&:id)).to eq(
          [
            investor_1.id,
            investor_2.id,
            investor_3.id,
            investor_4.id
          ]
        )
      end
    end

    context 'order by deals' do
      let(:options) { { order: :deals } }

      it '#call!' do
        expect(subject.call!.map(&:id)).to eq(
          [
            investor_3.id,
            investor_2.id,
            investor_4.id,
            investor_1.id
          ]
        )
      end
    end
    context 'order by capital'
    context 'order by location'
  end
end
