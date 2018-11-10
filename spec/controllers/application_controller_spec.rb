# frozen_string_literal: true

describe ApplicationController do
  describe '#not_found', type: :feature do
    it 'handles routing error' do
      visit '/undefined_route'

      expect(page.status_code).to eq(404)
      expect(page).to have_content('Page not found')
    end

    it 'handles record not found error' do
      visit Rails.application.routes.url_helpers.company_path(id: :undefined)

      expect(page.status_code).to eq(404)
    end
  end
end
