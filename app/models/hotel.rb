class Hotel < ApplicationRecord
  has_many :room_types
  has_many :hotel_rooms

  validates :name, presence: true
end
