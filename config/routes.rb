Rails.application.routes.draw do
  root "payment#checkout"
  resource :payment, only: %i[ create ]
  post "/webhooks/stripe", to: "webhooks#stripe"
end
