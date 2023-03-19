class EmployeeAddress < ApplicationRecord
  belongs_to :employee

  validates :street, presence: true
end
