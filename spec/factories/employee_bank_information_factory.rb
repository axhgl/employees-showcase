FactoryBot.define do
  factory :employee_bank_information do
    card_expiration { Faker::Business.credit_card_expiry_date.strftime("%m/%y") }
    card_number { Faker::Business.credit_card_number }
    card_type { Faker::Business.credit_card_type }
    currency { Faker::Currency.name }
    iban { Faker::Bank.iban }
    employee
  end
end
