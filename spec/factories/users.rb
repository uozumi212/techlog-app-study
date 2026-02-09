FactoryBot.define do
  factory :user do
    nickname { Faker::Japanese::Name.name }
    sequence :email do |n|
      "test#{n}@example.com"
    end
    password { 'Password123' }
    password_confirmation { 'Password123' }
    
    trait :with_posts do
    	nickname { Faker::Name.name }
    end
  end
end
