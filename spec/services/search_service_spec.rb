describe SearchService do
  describe '#fetch' do
    it 'fetches the records according to requested filters' do
      create(:company, name: "Pucca's Network Solutions")
      create(:company, name: "Bahia's Artificial Intelligence")

      filter_value = 'Artificial'
      model = Company
      filter_params = {
        fields: 'Name',
        operators: 'contains',
        values: filter_value
      }
      domain_country_context = 'br'

      result = described_class.new(
        model,
        filter_params,
        domain_country_context
      ).fetch

      expect(result.count).to eq(1)
      expect(result.first.name).to eq("Bahia's Artificial Intelligence")
    end
  end
end
