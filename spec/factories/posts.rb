FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 5) }
    content { Faker::Lorem.paragraph(sentence_count: 10) }
    association :user, factory: :user

    trait :with_rails_content do
      title { 'Rails入門 - ' + Faker::Lorem.word }
      content { 'Railsについて学習しました。' + Faker::Lorem.paragraph(sentence_count: 5) }
    end

    trait :with_ruby_content do
      title { 'Ruby基礎 - ' + Faker::Lorem.word }
      content { 'Rubyについて学習しました。' + Faker::Lorem.paragraph(sentence_count: 5) }
    end

    trait :old_post do
      created_at { 30.days.ago }
    end

    trait :recent_post do
      created_at { 1.day.ago }
    end

    trait :with_tags do
      after(:create) { |post| create_list(:tag, 3, posts: [post]) }
    end
  end
end
