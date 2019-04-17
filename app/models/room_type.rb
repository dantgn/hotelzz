class RoomType < ApplicationRecord
  belongs_to :hotel
  has_many :hotel_rooms
  has_many :bookings
  has_many :room_type_prices

  validates :name, presence: true
  validates :occupancy_limit, presence: true
  validates :number_of_rooms, presence: true
end
