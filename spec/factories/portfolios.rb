FactoryBot.define do
    factory :portfolio do
      association :user
  
      stocks { 'AAPL' }
      current_shares { 0.0 }
    end
  end
  