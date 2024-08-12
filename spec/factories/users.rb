FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    admin { "0" }

    trait :admin do
      admin { "1" }
    end
  end
end
