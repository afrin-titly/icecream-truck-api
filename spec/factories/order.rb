FactoryBot.define do
  factory :order do
    order_number { Faker::Number.unique.number(digits: 10) }
    total_amount { Faker::Commerce.price(range: 10.0..500.0) }
    association :user
  end
end
