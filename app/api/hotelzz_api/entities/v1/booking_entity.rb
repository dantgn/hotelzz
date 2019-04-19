module HotelzzAPI
  module Entities
    module V1
      class BookingEntity < Grape::Entity
        expose :id
        expose :guest, using: HotelzzAPI::Entities::V1::GuestEntity
        expose :room_type, using: HotelzzAPI::Entities::V1::RoomTypeEntity
        expose :check_in
        expose :check_out
      end
    end
  end
end
