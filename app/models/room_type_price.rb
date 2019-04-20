# frozen_string_literal: true

class RoomTypePrice < ApplicationRecord
  belongs_to :room_type

  validates :currency, presence: true
  validates :amount, presence: true
  validates :month, presence: true
end
