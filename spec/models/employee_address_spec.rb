require 'rails_helper'

RSpec.describe EmployeeAddress do
  context "validations" do
    let!(:employee_address) { create(:employee_address) }

    it { should validate_presence_of(:street) }
  end
end
