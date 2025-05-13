FactoryBot.define do
  factory :transaction do
    association :user

    symbol { 'AAPL' }
    shares { 2.0 }
    price { 150.0 }
    total { 300.0 }
    action_type { 'buy' }
  end
end
