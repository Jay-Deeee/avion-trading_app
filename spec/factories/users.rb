FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    email      { "johndoe@gmail.com" }
    password   { "asdfgh" }
    balance    { 5000.00 }
    approved   { true }
    confirmed_at { Time.current }
  end
end
