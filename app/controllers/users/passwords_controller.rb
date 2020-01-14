module Users
  class PasswordsController < Devise::PasswordsController
    def new
      @blank_layout = true
      super
    end
  end
end
