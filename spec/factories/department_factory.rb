FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "#{Faker::Commerce.department}-#{n}" }
    company
  end
end

