class Company < ApplicationRecord
  has_one :company_address, dependent: :destroy
  has_many :employees
  has_many :departments, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
