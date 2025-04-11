class WebhooksController < ApplicationController
  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: 400 and return
    end

    case event["type"]
    when "payment_intent.succeeded"
      payment_intent = event["data"]["object"]
      Rails.logger.info("✅ Payment succeeded: #{payment_intent['id']}")
    when "payment_intent.payment_failed"
      Rails.logger.info("❌ Payment failed")
    end

    render json: { message: "Webhook received" }
  end
end
