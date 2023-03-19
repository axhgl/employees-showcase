class Department < ApplicationRecord
  belongs_to :company, counter_cache: true

  validates :name, uniqueness: { scope: :company_id }, presence: true
end
