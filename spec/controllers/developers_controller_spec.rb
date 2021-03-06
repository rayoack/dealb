# frozen_string_literal: true

describe DevelopersController, :vcr do
  describe '#index' do
    subject(:index) { get :index }

    it 'returns 200' do
      index

      expect(response.status).to eq(200)
    end
  end
end
