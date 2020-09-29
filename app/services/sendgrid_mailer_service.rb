class SendgridMailerService
    include SendGrid, HomeHelper, ApplicationHelper

    def sendNews()

        updates = Deal
                .preload(:investors, :company)
                .left_outer_joins(:company)
                .distinct
                .select('deals.*, companies.name AS company_name')
                .where(created_at: 7.days.ago..Time.zone.now)
                .order(close_date: :asc)
        newsHtml = [];

        if updates.length == 0
            puts "No updates today"
            return nil
        end
        formatted_updates(updates).each do |deal|
            newsHtml.push( <<-HTML
                <div style="font-family: inherit; text-align: inherit; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(221, 221, 221); padding-bottom: 10px">
                    <a href="https://dealbook.co/deals/#{deal[:id]}" style="text-decoration: none">
                    <span style="color: #2f438b">
                        <strong>#{deal[:date]}</strong>
                        </span>
                    </a>
                    <br />
                    <a href="https://dealbook.co/deals/#{deal[:id]}"  style="text-decoration: none">
                    <span style="color: #363c49">
                    #{deal[:description]}
                    </span>
                    </a>
                </div>
                HTML
            )
        end

        p = 0
        loop do
            users = User.order(id: :asc).limit( 50 ).offset( 50 * p )
                .where( id: 2178 )
            p = p + 1

            if users.empty?
                break
            end

            puts "send to users ", users.first.id, users.last.id, "\n"
            sendNewsToUsers( users, newsHtml )
        end

    end
    def sendNewsToUsers( users, newsHtml )
        mail = Mail.new
        mail.from = Email.new(email: 'news@dealbook.co')

        users.each do |user|
            personalization = Personalization.new
            personalization.add_to(Email.new(email: user.email, name: user.person ? user.person.name : 'Dealbook user'))
            personalization.add_dynamic_template_data({
                "subject" => "Dealbook Digest ##{DateTime.now().strftime('%F')}",
                "Deals" => newsHtml.join('<br />')
            })
            mail.add_personalization(personalization)
        end

        mail.template_id = 'd-211ff0e4ac3843909a838d69c9bb1ef2'

        sg = SendGrid::API.new(api_key: ENV['SENDGRID_KEY'])
        begin
            response = sg.client.mail._("send").post(request_body: mail.to_json)
        rescue Exception => e
            puts e.message
        end
    end
end
