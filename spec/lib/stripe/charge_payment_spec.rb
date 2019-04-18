require 'rails_helper'

RSpec.describe Stripe::ChargePayment do
  let(:service) { described_class.new(booking: booking, amount: amount, currency: currency, source: source) }
  let(:booking) { Fabricate(:booking, status: 'unpaid') }
  let(:amount) { 5 }
  let(:currency) { 'usd' }
  let(:source) { 'tok_mastercard' }
  let(:expected_charge_description) do
    "Charge for #{booking.guest.email}, hotelzz booking '#{booking.id}'"
  end
  let(:stripe_response) do
    {
      'status'  => stripe_response_status,
      'id'      => stripe_charge_id
    }
  end
  let(:stripe_response_status) { 'succeeded' }
  let(:stripe_charge_id) { 'ch_123456789' }

  describe '#call' do
    subject { service.call }

    before do
      allow(Stripe::Charge).
        to receive(:create).
        with(
          amount: 500,
          currency: currency,
          source: source,
          description: expected_charge_description
        ).
        and_return(stripe_response)
    end

    context 'when stripe returns successful payment' do
      it { expect(subject).to eq(true) }

      it 'creates a new payment record' do
        expect { subject }.
          to change {
            Payment.where(
              booking_id: booking.id,
              charge_id: stripe_charge_id,
              amount: amount,
              currency: currency,
              status: 'paid'
            ).count
          }.from(0).to(1)
      end

      it 'updates booking status to paid' do
        expect { subject }.
          to change {
            booking.status
          }.from('unpaid').to('paid')
      end
    end

    context 'when stripe returns a failed payment' do
      before do
        allow(Stripe::Charge).
          to receive(:create).
          and_raise('No such token: tok_xxxxxx')
      end

      it { expect(subject).to eq(false) }

      it 'creates a new payment record' do
        expect { subject }.
          to change {
            Payment.where(
              booking_id: booking.id,
              charge_id: 'error on charge',
              amount: amount,
              currency: currency,
              status: 'payment_failed',
              info: 'No such token: tok_xxxxxx'
            ).count
          }.from(0).to(1)
      end

      it 'updates booking status to paid' do
        expect { subject }.
          to change {
            booking.status
          }.from('unpaid').to('payment_failed')
      end
    end

    context 'when currency is eur' do
      let(:currency) { 'eur' }

      it "'calls stripe charge with currency set to 'eur'" do
        expect(Stripe::Charge).
          to receive(:create).
          with(
            amount: 500,
            currency: 'eur',
            source: source,
            description: expected_charge_description
          )

        subject
      end
    end
  end
end
