module Users
  class SessionsController < Devise::SessionsController
    def new
      @blank_layout = true

      super
    end
  end
end
