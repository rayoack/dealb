# frozen_string_literal: true

describe SearchController do
  describe '#index' do
    let(:global_search) { { global_search: 'ab' } }
    subject(:index) { get :index, params: global_search }

    it 'returns the global_search result' do
      person = create(:person, first_name: 'Abc')
      company = create(:company, name: 'aBcD')

      index

      expect(assigns(:results)).to eq([person, company])
    end
  end
end
