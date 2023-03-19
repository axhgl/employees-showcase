require 'rails_helper'

RSpec.describe InitialDataFetchJob do
  describe "#perform" do
    it "invokes the FetchAndDataCreationServicejla" do
      expect_any_instance_of(FetchAndDataCreationService).to receive(:call)

      described_class.new.perform(0, 10)
    end
  end
end
