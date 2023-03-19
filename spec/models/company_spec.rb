require 'rails_helper'

RSpec.describe Company do
  context "validations" do
    let!(:company) { create(:company) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
