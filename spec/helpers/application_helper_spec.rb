describe ApplicationHelper do
  describe '#format_amount' do
    it 'formats USD amounts' do
      expect(helper.format_amount(9_876, 'USD')).to eq('USD 9,9 k')
      expect(helper.format_amount(9_876_543, 'USD')).to eq('USD 9,9 mi')
      expect(helper.format_amount(9_876_543_210, 'USD')).to eq('USD 9,9 bi')
    end

    it 'formats BRL amounts' do
      expect(helper.format_amount(9_876, 'BRL')).to eq('R$ 9,9 k')
      expect(helper.format_amount(9_876_543, 'BRL')).to eq('R$ 9,9 mi')
      expect(helper.format_amount(9_876_543_210, 'BRL')).to eq('R$ 9,9 bi')
    end
  end
end
