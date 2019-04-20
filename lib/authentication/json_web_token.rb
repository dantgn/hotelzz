# frozen_string_literal: true

# User authentication by JWT
# JWT for Guests and HotelManagers authenticated API requests
# Tokens have a payload like, 
# {
#   user_id: `id`,
#   exp: 123456789
# }
# where id belong Guest or HotelManager
# expiration will not be considered on this task

module Authentication
  class JsonWebToken
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY).first
      HashWithIndifferentAccess.new(decoded)
    end
  end
end
