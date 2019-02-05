describe LanguageService do
  describe '#set_language' do
    it 'sets the language based on browser preferences by default' do
      params = {}
      cache = {}
      browser = double(:browser_preferences, compatible_language_from: 'pt-br')
      language_service = described_class.new(params, cache, browser)

      language_service.set_language

      expect(cache['language']).to eq('pt-br')
    end

    it 'maintains the cached language when it is not changed' do
      params = {}
      cache = { 'language' => 'pt-br' }
      browser = double(:browser_preferences)
      language_service = described_class.new(params, cache, browser)

      language_service.set_language

      expect(cache['language']).to eq('pt-br')
    end

    it 'sets the selected language when changed by user' do
      params = { language: 'pt-br' }
      cache = { 'language' => 'en' }
      browser = double(:browser_preferences)
      language_service = described_class.new(params, cache, browser)

      language_service.set_language

      expect(cache['language']).to eq('pt-br')
    end
  end

  after { I18n.locale = 'en' }
end
