# frozen_string_literal: true

class RoomType < ApplicationRecord
  belongs_to :hotel
  has_many :hotel_rooms
  has_many :bookings
  has_many :room_type_prices

  validates :name, presence: true
  validates :occupancy_limit, presence: true
  validates :number_of_rooms, presence: true

  def available?(check_in:, check_out:)
    bookings.paid.where(
      '(? BETWEEN check_in AND check_out) OR (? BETWEEN check_in AND check_out)',
      check_in, check_out
    ).count < number_of_rooms
  end
end
