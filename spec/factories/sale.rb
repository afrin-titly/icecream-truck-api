FactoryBot.define do
  factory :sale do
    quantity { Faker::Number.between(from: 1, to: 10) }
    total_price { Faker::Commerce.price(range: 10.0..500.0) }
    association :item
    association :order
  end
end
