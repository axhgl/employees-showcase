FactoryBot.define do
  factory :employee_address do
    street { Faker::Address.street_address }
    coordinates { [Faker::Address.latitude, Faker::Address.longitude] }
    employee
  end
end
