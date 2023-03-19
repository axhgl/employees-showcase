require 'rails_helper'

RSpec.describe CompanyAddress do
  context "validations" do
    let!(:company_address) { create(:company_address) }

    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:coordinates) }
  end
end
