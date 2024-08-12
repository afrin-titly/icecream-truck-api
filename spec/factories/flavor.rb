FactoryBot.define do
  factory :flavor do
    name { Faker::Food.flavor }
  end
end
