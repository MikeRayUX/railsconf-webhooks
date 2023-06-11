class Webhooks::BaseController < ApplicationController
  # Disable CSRF checks on webhooks because they don not originate from the browser
  # skip_before_action :verify_authenticity_token
  skip_forgery_protection

  before_action :verify_event

  def create
    # 1. Stash payload in db
    InboundWebhook.create!(body: payload)
    # 2. Tell stripe/service 'thank you! it has been stored successfully'
    head :ok
  end

  private

  def verify_event
    head :bad_request
  end

  def payload
    @payload ||= request.body.read
  end
end
