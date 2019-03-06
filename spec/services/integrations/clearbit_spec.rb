describe Integrations::Clearbit, :vcr do
  context '#enrich' do
    subject { described_class.new(resource).enrich }

    context 'enrich company' do
      let(:resource) do
        create :company, name: 'Spotify',
                         founded_on: nil,
                         employees_count: nil,
                         stock_symbol: nil,
                         homepage_url: nil,
                         facebook_url: nil,
                         twitter_url: nil,
                         linkedin_url: nil,
                         crunchbase_url: nil,
                         profile_image_url: nil
      end

      it 'success' do
        subject

        resource.reload

        expect(resource).to have_attributes(
          employees_count: 4960,
          homepage_url: 'https://spotify.com',
          linkedin_url: 'https://linkedin.com/company/spotify',
          facebook_url: 'https://facebook.com/spotify',
          twitter_url: 'https://twitter.com/Spotify',
          crunchbase_url: 'https://crunchbase.com/organization/spotify',
          profile_image_url: 'https://logo.clearbit.com/spotify.com',
          stock_symbol: 'SPOT'
        )
      end

      context 'do not override' do
        let(:resource) do
          create :company, name: 'Spotify',
                           founded_on: nil,
                           employees_count: 99,
                           stock_symbol: nil,
                           homepage_url: 'https://homepage.com',
                           facebook_url: 'https://facebook.com/somepage',
                           twitter_url: nil,
                           linkedin_url: nil,
                           crunchbase_url: nil,
                           profile_image_url: nil
        end

        it 'success' do
          subject

          resource.reload

          expect(resource).to have_attributes(
            employees_count: 99,
            homepage_url: 'https://homepage.com',
            linkedin_url: 'https://linkedin.com/company/spotify',
            facebook_url: 'https://facebook.com/somepage',
            twitter_url: 'https://twitter.com/Spotify',
            crunchbase_url: 'https://crunchbase.com/organization/spotify',
            profile_image_url: 'https://logo.clearbit.com/spotify.com',
            stock_symbol: 'SPOT'
          )
        end
      end
    end

    context 'enrich person' do
      let(:resource) do
        create :person, first_name: 'larry',
                        email: 'larry@google.com',
                        last_name: nil,
                        description: nil,
                        occupation: nil,
                        website_url: nil,
                        facebook_url: nil,
                        twitter_url: nil,
                        linkedin_url: nil,
                        profile_image_url: nil
      end

      it 'success' do
        subject

        resource.reload

        expect(resource).to have_attributes(
          first_name: 'larry',
          last_name: 'Page',
          email: 'larry@google.com',
          bio: 'Co-Founder & President, Product of Google',
          occupation: 'Co-founder, President, Products',
          website_url: 'http://www.quora.com/Larry-Page',
          facebook_url: 'https://facebook.com/',
          twitter_url: 'https://twitter.com/q_larrypage',
          linkedin_url: 'https://linkedin.com/in/tlytle'
        )
      end

      context 'do not override' do
        let(:resource) do
          create :person, first_name: 'larry',
                          email: 'larry@google.com',
                          last_name: 'New Page',
                          description: nil,
                          occupation: nil,
                          website_url: 'https://dealbook.co',
                          facebook_url: nil,
                          twitter_url: 'https://twitter.com/dealbook',
                          linkedin_url: nil,
                          profile_image_url: nil
        end

        it 'success' do
          subject

          resource.reload

          expect(resource).to have_attributes(
            first_name: 'larry',
            last_name: 'New Page',
            email: 'larry@google.com',
            bio: 'Co-Founder & President, Product of Google',
            occupation: 'Co-founder, President, Products',
            website_url: 'https://dealbook.co',
            facebook_url: 'https://facebook.com/',
            twitter_url: 'https://twitter.com/dealbook',
            linkedin_url: 'https://linkedin.com/in/tlytle'
          )
        end
      end
    end
  end
end
