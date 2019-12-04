# frozen_string_literal: true

class Deal < ApplicationRecord
  CATEGORIES = [
    RAISED_FUNDS_FROM = 'raised_funds_from',
    INCUBATED_BY = 'incubated_by',
    MERGED_WITH = 'merged_with',
    WAS_ACQUIRED_BY = 'was_acquired_by',
    SHUTDOWN = 'shutdown'
  ].freeze

  ROUNDS = [
    ACCELERATION = 'acceleration',
    SERIES_SEED = 'series_seed',
    SERIES_A = 'series_a',
    SERIES_B = 'series_b',
    SERIES_C = 'series_c',
    SERIES_D = 'series_d',
    SERIES_E = 'series_e',
    IPO = 'ipo',
    SEED = 'seed',
    ANGEL = 'angel',
    VENTURE = 'venture',
    EQUITY_CROWDFUNDING = 'equity_crowdfunding',
    PRODUCT_CROWDFUNDING = 'product_crowdfunding',
    PRIVATE_EQUITY = 'private_equity',
    CONVERTIBLE_NOTE = 'convertible_note',
    DEBT_FINANCING = 'debt_financing',
    SECONDARY_MARKET = 'secondary_market',
    GRANT = 'grant',
    POST_IPO_EQUITY = 'post_ipo_equity',
    POST_IPO_DEBT = 'post_ipo_debt',
    NON_EQUITY_ASSISTANCE = 'non_equity_assistance',
    UNDISCLOSED = 'undisclosed',
    UNKNOWN = 'unknown'
  ].freeze

  CURRENCIES = [
    USD = 'USD',
    BRL = 'BRL'
  ].freeze

  STATUSES = [UNVERIFIED = 'unverified', VERIFIED = 'verified'].freeze

  # Validations
  validates :close_date, :company_id, :status, :category, presence: true

  validates :close_date, date: true
  validates :close_date, date: { before_or_equal_to: proc { Time.zone.today } }

  validates :category, inclusion: { in: CATEGORIES }
  validates :status, inclusion: { in: STATUSES }
  validates :round, inclusion: { in: ROUNDS }, allow_nil: true
  validates :amount_currency, inclusion: { in: CURRENCIES }, allow_nil: true
  validates(
    :amount,
    numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  )
  validates(
    :pre_valuation_currency, inclusion: { in: CURRENCIES }, allow_nil: true
  )
  validates(
    :pre_valuation,
    numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  )
  validates :source_url, url: true, allow_nil: true

  # Relations
  belongs_to :company
  belongs_to :user
  has_many :deal_investors, dependent: :destroy
  has_many :investors, through: :deal_investors

  # Nested
  accepts_nested_attributes_for :deal_investors

  # Scopes
  scope :top_contributors, lambda { |amount|
    joins(:user).select('users.id as user_id', 'COUNT(*) as number_of_deals')
                .group('users.id')
                .order('number_of_deals desc')
                .limit(amount)
  }

  # before_save do
    # self.exchange_rates = ActionController::Base.helpers.exchange_rates(self) if !self.exchange_rates.present?
    # self.amount_dolar = self.amount * self.exchange_rates if self.amount_currency == 'BRL'
    # self.pre_valuation_dolar = 
  # end
end
