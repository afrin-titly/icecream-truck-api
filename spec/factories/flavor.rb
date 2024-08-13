FactoryBot.define do
  factory :flavor do
    name { Faker::Commerce.department }
  end
end
