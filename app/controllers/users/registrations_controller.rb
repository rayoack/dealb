module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_sign_up_path_for(_resource)
      new_person_path
    end

    def after_update_path_for(_resource)
      new_person_path
    end
  end
end
