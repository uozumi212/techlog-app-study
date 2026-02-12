FactoryBot.define do
  factory :like do
    association :post, factory: :post
    association :user, factory: :user
  end
end
