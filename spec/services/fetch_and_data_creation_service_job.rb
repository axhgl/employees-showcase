require 'rails_helper'

RSpec.describe FetchAndDataCreationService do
  describe "#call", :vcr do
    subject { FetchAndDataCreationService.new(0, 10).call }

    let!(:response) { HTTParty.get('https://dummyjson.com/users') }

    before do
      allow(HTTParty).to receive(:get).and_return(response)
    end

    it "returns a message in case the request wasn't successful" do
      allow(response).to receive(:success?).and_return false

      expect(subject).to eq("Error retrieving users: #{response.code} - #{response.message}")

      subject
    end

    it "creates employees, employee addresses and each employee's bank information" do
      subject

      expect(Employee.limit(1)).to_not be_empty
      expect(EmployeeAddress.limit(1)).to_not be_empty
      expect(EmployeeBankInformation.limit(1)).to_not be_empty
    end

    it "creates companies, company addresses and departments" do
      subject

      expect(Company.limit(1)).to_not be_empty
      expect(CompanyAddress.limit(1)).to_not be_empty
      expect(Department.limit(1)).to_not be_empty
    end
  end
end
