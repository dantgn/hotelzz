# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :hotel
  belongs_to :room_type
  belongs_to :guest
  has_many :payments

  STATUS = %w[canceled paid payment_failed unpaid].freeze

  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :status, inclusion: { in: STATUS }

  scope :paid, -> { where(status: 'paid') }
end
