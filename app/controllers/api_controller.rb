class ApiController < ApplicationController
  before_action :authenticate_user!, except: %i[info]
end
