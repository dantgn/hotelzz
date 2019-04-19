module HotelzzAPI
  module Helpers
    module JwtAuthenticationHelper
      def authenticated_jwt_guest?
        auth_token = request.headers['Authorization']
        begin
          decoded = ::Authentication::JsonWebToken.decode(auth_token)
          Guest.find(decoded[:guest_id])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          error!('401 Unauthorized', 401)
        end
      end
    end
  end
end
