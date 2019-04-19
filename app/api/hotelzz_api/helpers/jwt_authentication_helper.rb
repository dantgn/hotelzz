module HotelzzAPI
  module Helpers
    module JwtAuthenticationHelper
      def jwt_authenticated_user(user_class)
        auth_token = request.headers['Authorization']
        begin
          decoded = ::Authentication::JsonWebToken.decode(auth_token)
          klass = user_class.safe_constantize
          klass.find(decoded[:user_id])
        rescue ActiveRecord::RecordNotFound
          error!('401 Unauthorized', 401)
        end
      end
    end
  end
end
