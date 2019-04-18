module HotelzzAPI
  module Entities
    module V1
      module Light
        class HotelEntity < Grape::Entity
          expose :id
          expose :name
        end
      end
    end
  end
end
