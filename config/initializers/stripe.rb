# Initialize Stripe API with different key depending on environment

Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_api]