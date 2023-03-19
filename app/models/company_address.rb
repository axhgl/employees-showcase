class CompanyAddress < ApplicationRecord
  belongs_to :company

  validates :street, :coordinates, presence: true
end
