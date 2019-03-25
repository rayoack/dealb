# frozen_string_literal: true

class EmbassadorController < ApplicationController
  def index
    @embassadors = Deal.top_contributors(3).map(&:user)
  end
end
