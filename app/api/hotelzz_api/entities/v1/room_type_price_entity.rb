module HotelzzAPI
  module Entities
    module V1
      class RoomTypePriceEntity < Grape::Entity
        expose :id
        expose :room_type_id
        expose :amount
        expose :currency
      end
    end
  end
end
