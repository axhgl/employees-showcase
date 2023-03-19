require 'rails_helper'

RSpec.describe Department do
  context "validations" do
    let!(:department) { create(:department) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:company_id) }
  end
end
