module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      @user = User.find_by(confirmation_token: params[:confirmation_token])

      if @user.present? && @user.confirm
        sign_in(@user)

        if @user.person.blank?
          redirect_to new_person_path,
                      notice: I18n.t('sessions.confirmation.success')
          return
        end

        redirect_to root_path, notice: I18n.t('sessions.confirmation.success')
      else
        redirect_to root_path, flash: {
          error: I18n.t('sessions.confirmation.failure')
        }
      end
    end
  end
end
