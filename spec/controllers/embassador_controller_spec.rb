# frozen_string_literal: true

describe EmbassadorController do
  describe '#index' do
    subject(:index) { get :index }

    let(:user) { create :user }
    let(:other_user) { create :user }

    before do
      # Three deals for top #1
      create :deal, user: user
      create :deal, user: user
      create :deal, user: user

      # Two deals for top #2
      create :deal, user: other_user
      create :deal, user: other_user

      # Withour deals
      create :user
    end

    it 'returns 200' do
      index

      expect(response.status).to eq(200)
      expect(assigns[:embassadors].map(&:id))
        .to eq([user.id, other_user.id])
    end
  end
end
