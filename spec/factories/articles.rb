FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: Random.new.rand(1..50)) }
    body { Faker::Lorem.paragraph }
    status { "published" }
    user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
