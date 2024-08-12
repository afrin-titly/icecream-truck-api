FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 1.0..100.0) }
    stock { Faker::Number.between(from: 1, to: 100) }
    association :category
    association :flavor
  end
end
