FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }

    trait :with_items do
      after(:create) do |category|
        create_list(:item, 3, category: category)
      end
    end
  end
end
