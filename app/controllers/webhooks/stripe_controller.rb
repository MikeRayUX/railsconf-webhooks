class Webhooks::StripeController < Webhooks::BaseController
  # curl -X POST http://localhost:3000/webhooks/stripe -H 'Content-Type: application/json' -d '{"title": "The Matrix"}'
  before_action :verify_event

  def create
    # 1. Stash payload in db
    record = InboundWebhook.create!(body: payload)
    # 2. Kick off a job
    Webhooks::StripeJob.perform_later(record)
    # 3. Tell stripe/service 'thank you! it has been stored successfully'
    head :ok
  end

  private

  def verify_event
    signature = request.headers['Stripe-Signature']
    secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)

    ::Stripe::Webhook::Signature.verify_header(
      payload,
      signature,
      secret.to_s,
      tolerance: Stripe::Webhook::DEFAULT_TOLERANCE
    )
  rescue ::Stripe::Signature::VerificationError
    head :bad_request
  end
end
