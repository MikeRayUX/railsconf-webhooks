class Webhooks::MoviesJob < ApplicationJob
  queue_as :default

  def perform(inbound_webhook)
      webhook_payload = JSON.parse(inbound_webhook.body, symbolize_names: true)

    # Movies.where(title: webhook_payload[:title]).find_or_create!


    inbound_webhook.update!(status: :processed)
  end
end
