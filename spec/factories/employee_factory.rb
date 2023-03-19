FactoryBot.define do
  factory :employee do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "#{Faker::Internet.email}-#{n}" }
    age { 30 }
    height { 200 }
    gender { Faker::Gender.binary_type.downcase }
    job_title { Faker::Job.title }
    company
  end
end

