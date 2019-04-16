class RoomType < ApplicationRecord
  belongs_to :hotel
  has_many :hotel_rooms
  has_many :bookings

  validates :name, presence: true
  validates :occupancy_limit, presence: true
  validates :number_of_rooms, presence: true
end
