module HotelzzAPI
  module Entities
    module V1
      class RoomTypeEntity < Grape::Entity
        expose :id
        expose :name
        expose :occupancy_limit
      end
    end
  end
end
