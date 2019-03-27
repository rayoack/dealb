class ApiController < ApplicationController
  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :authenticate_user!, except: %i[info]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
