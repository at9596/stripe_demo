class PaymentController < ApplicationController
  def checkout
    @amount = 5000
    @payment_intent = Stripe::PaymentIntent.create({
      amount: @amount,
      currency: "usd",
      description: "Test Payment",
      metadata: { user_id: 1 }
    })
  end

  def create
    # usually handled by Stripe.js;
    
  end
end
