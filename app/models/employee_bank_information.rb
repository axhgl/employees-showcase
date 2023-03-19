class EmployeeBankInformation < ApplicationRecord
  belongs_to :employee

  validates :card_expiration, :card_number, :card_type, :currency, :iban, presence: true
  validates :card_expiration, format: { with: /\A\d{2}\/\d{2}\z/, message: "must be in the format MM/YY" }
end
