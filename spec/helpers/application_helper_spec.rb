describe ApplicationHelper do
  describe '#format_amount' do
    it 'formats USD amounts' do
      expect(helper.format_amount(9_876, 'USD')).to eq('$9.9 Thousand')
      expect(helper.format_amount(9_876_543, 'USD')).to eq('$9.9 Million')
      expect(helper.format_amount(9_876_543_210, 'USD')).to eq('$9.9 Billion')
    end
  end
end
