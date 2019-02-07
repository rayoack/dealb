# frozen_string_literal: true

class MyUser < ActiveRecord::Base
  self.table_name = 'users'
end

class ImportOldDatabaseService
  class ImportUser
    # rubocop:disable Metrics/MethodLength
    def run
      ImportOldDatabaseService::Entities::User.find_each do |user|
        printf('.')

        @user = user

        new_user = ::MyUser.new(
          email: user.email,
          encrypted_password: user.encrypted_password,
          # reset_password_token: '',
          # reset_password_sent_at: '',
          # remember_created_at: '',
          sign_in_count: user.sign_in_count,
          # current_sign_in_at: '',
          # last_sign_in_at: '',
          # current_sign_in_ip: '',
          # last_sign_in_ip: '',
          provider: user.provider,
          uid: user.uid,
          role: (user.role == 'normal' ? 'user' : user.role)
        )

        new_user.save!
      end

      warn "\nImported user - final statistics"
      warn("count: #{::User.count} users")
    rescue StandardError
      raise
    end
    # rubocop:enable Metrics/MethodLength
  end
end
