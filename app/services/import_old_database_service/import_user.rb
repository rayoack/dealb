# frozen_string_literal: true

class MyUser < ActiveRecord::Base
  self.table_name = 'users'
end

class ImportOldDatabaseService
  class ImportUser
    # rubocop:disable Metrics/MethodLength
    def run
      Rails.logger.info('-- user')
      ImportOldDatabaseService::Entities::User.find_each do |user|
        printf('.')
        @user = user
        new_user = ::MyUser.new(
          id: user.id,
          email: user.email,
          encrypted_password: user.encrypted_password,
          sign_in_count: user.sign_in_count,
          provider: user.provider,
          uid: user.uid,
          role: (user.role == 'normal' ? 'user' : user.role),
          last_sign_in_at: user.last_sign_in_at,
          last_sign_in_ip: user.last_sign_in_ip,
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        new_user.save!
      end
      Rails.logger.info("-- imported #{::User.count} users")
    end
    # rubocop:enable Metrics/MethodLength
  end
end
