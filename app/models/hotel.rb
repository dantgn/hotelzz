class Hotel < ApplicationRecord
  has_many :room_types
  has_many :hotel_rooms
  has_many :bookings

  validates :name, presence: true
end
