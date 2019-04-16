class RoomType < ApplicationRecord
  belongs_to :hotel
  has_many :hotel_rooms

  validates :name, presence: true
  validates :occupancy_limit, presence: true
end
