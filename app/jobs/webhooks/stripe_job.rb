class Webhooks::StripeJob < ApplicationJob
  queue_as :default

  def perform(inbound_webhook)
    json = JSON.parse(inbound_webhook.body, symbolize_names: true)
    event = Stripe::Event.construct_from(json)

    case event.type
    when 'customer.updated'
      # Find customer and update their details
      inbound_webhook.update!(status: :processed)
    # when 'more conditions' ...
    else
      inbound_webhook.update!(status: :skipped)
    end
  end
end
