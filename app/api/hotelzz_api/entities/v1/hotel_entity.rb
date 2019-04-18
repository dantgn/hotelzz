module HotelzzAPI
  module Entities
    module V1
      class HotelEntity < Grape::Entity
        expose :id
        expose :name
        expose :room_types, using: HotelzzAPI::Entities::V1::Light::RoomTypeEntity
      end
    end
  end
end
