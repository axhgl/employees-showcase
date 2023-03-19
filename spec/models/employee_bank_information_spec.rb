require 'rails_helper'

RSpec.describe EmployeeBankInformation do
  context "validations" do
    let!(:emp_bank_info) { create(:employee_bank_information) }

    it { should validate_presence_of(:card_expiration) }
    it { should validate_presence_of(:card_number) }
    it { should validate_presence_of(:card_type) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:iban) }

    describe "#card_expiration" do
      it "should validate that the card expiration attribute is in mm/yy format" do
        bank_info = EmployeeBankInformation.new(
          card_expiration: "03/25",
          card_number: "123456789123456",
          card_type: "Visa",
          currency: "US Dollar",
          iban: "iban-no",
          employee: emp_bank_info.employee
        )
        expect(bank_info).to be_valid

        bank_info.card_expiration = '03/2025'
        expect(bank_info).to_not be_valid

        bank_info.card_expiration = '03-25'
        expect(bank_info).to_not be_valid

        bank_info.card_expiration = '0325'
        expect(bank_info).to_not be_valid
      end
    end
  end
end
