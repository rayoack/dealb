describe Tag, type: :model do
  context 'validations' do
    let(:company) { create :company }

    context 'belongs to company' do
      it 'success' do
        tag = build :tag, company: company

        expect(tag.valid?).to be_truthy
      end

      it 'failure' do
        tag = build :tag, company: nil

        expect(tag.valid?).to be_falsey
      end
    end
  end
end
