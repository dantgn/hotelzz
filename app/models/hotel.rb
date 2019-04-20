# frozen_string_literal: true

class Hotel < ApplicationRecord
  has_many :room_types
  has_many :bookings
  belongs_to :hotel_manager

  validates :name, presence: true
end
