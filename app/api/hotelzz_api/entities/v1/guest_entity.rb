module HotelzzAPI
  module Entities
    module V1
      class GuestEntity < Grape::Entity
        expose :id
        expose :first_name
        expose :last_name
        expose :email
      end
    end
  end
end
