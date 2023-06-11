class Webhooks::MoviesController < Webhooks::BaseController
  # curl -X POST http://localhost:3000/webhooks/movies -H 'Content-Type: application/json' -d '{"title": "The Matrix"}'

  before_action :verify_event

  def create
    # 1. Stash payload in db
    record = InboundWebhook.create!(body: payload)
    # 2. Kick off a job
    Webhooks::MoviesJob.perform_later(record)
    # 3. Tell stripe/service 'thank you! it has been stored successfully'
    head :ok
  end

  private

  def verify_event
    head :bad_request if params[:fail_verification]
  end
end
