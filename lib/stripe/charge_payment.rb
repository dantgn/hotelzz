# This service will provide a payment charge in stripe
# The source is the token from the credit card. 
# For this example we assume the token will be fetched in the Frontend while introducing credit card details,
# and passed to the service. For testing purposes a valid testing token from stripe is set as default.

module Stripe
  class ChargePayment
    RESPONSE_OK = 'succeeded'.freeze

    def initialize(booking:, amount:, currency: 'usd', source: 'tok_mastercard')
      @booking = booking
      @amount = amount
      @currency = currency
      @source = source
    end

    def call
      begin
        response = charge!
        store_payment_details(response: response)
      rescue StandardError => error
        response = OpenStruct.new('status': 'failed', 'id': 'error on charge')
        store_payment_details(response: response, info: error.message)
      end
      response['status'] == RESPONSE_OK
    end

    private

    def charge!
      Stripe::Charge.create(
        amount: integer_amount_in_cents,
        currency: @currency,
        source: @source, # obtained in frontend with Stripe.js
        description: "Charge for #{@booking.guest.email}, hotelzz booking '#{@booking.id}'"
      )
    end

    # Stripe payment amount requirements
    def integer_amount_in_cents
      (@amount * 100).to_i
    end

    def store_payment_details(response:, info: nil)
      status = response['status'] == RESPONSE_OK ? 'paid' : 'payment_failed'
      @booking.update(status: status)

      ::Payment.create!(
        booking_id: @booking.id,
        charge_id: response['id'],
        amount: @amount,
        currency: @currency,
        status: status,
        info: info
      )
    end
  end
end
