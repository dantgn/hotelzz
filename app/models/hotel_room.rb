class HotelRoom < ApplicationRecord
  belongs_to :hotel
  belongs_to :room_type

  validates :number, presence: true
end
