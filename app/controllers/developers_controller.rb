require('integrations/github')

class DevelopersController < ApplicationController
  def index
    @developers = Github.all_contributors(except: users_to_ignore)
  end

  private

  # As the informations are not complete on GitHub
  def users_to_ignore
    %i[pgt fernandoalmeida lucaspbordignon lucianot dttg]
  end
end
