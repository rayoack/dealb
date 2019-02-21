# Github integration client
class Github
  def respository(user: 'Bossabox')
    client.respository(user: user, repo: 'dealbook')
  end

  private

  ACCESS_TOKEN = ENV['DEALBOOK_GITHUB_ACCESS_TOKEN'].freeze

  def client
    @client ||= Octokit::Client.new(access_token: ACCESS_TOKEN)
  end
end
