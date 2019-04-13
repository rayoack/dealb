# frozen_string_literal: true

class User < ApplicationRecord
  ROLES = [
    USER = 'user',
    MODERATOR = 'moderator',
    ADMIN = 'admin'
  ].freeze

  STATUSES = [ACTIVE = 'active', BLOCKED = 'blocked'].freeze

  validates :email, :role, presence: true
  validates :email, uniqueness: true
  validates :role, inclusion: { in: ROLES }
  validates :status, inclusion: { in: STATUSES }

  has_many :deals, dependent: :nullify

  belongs_to :person, optional: true

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :confirmable,
    omniauth_providers: [:linkedin]
  )

  def self.from_omniauth(auth)
    @user = find_by(email: auth&.info&.email)
    @user ||= find_or_initialize_by(provider: auth.provider,
                                    uid: auth.uid)

    return @user unless @user.new_record?

    @user.email = auth.info.email
    @user.password = Devise.friendly_token[0, 20]
    @user.save!
    @user
  end
end
