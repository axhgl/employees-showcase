FactoryBot.define do
  factory :company_address do
    street { Faker::Address.street_address }
    coordinates { [Faker::Address.latitude, Faker::Address.longitude] }
    company
  end
end
