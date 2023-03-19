require 'rails_helper'

RSpec.describe InitialDataCreationJob do
  subject { described_class.new.perform }

  describe "#perform", :vcr do
    let!(:response) { HTTParty.get('https://dummyjson.com/users') }

    before do
      allow(HTTParty).to receive(:get).and_return(response)
    end

    it "issues a request to the external endpoint" do
      expect(HTTParty).to receive(:get)

      subject
    end

    it "returns an error message in case the request wasn't successful" do
      allow(response).to receive(:success?).and_return false

      expect(subject).to eq("Error retrieving users: #{response.code} - #{response.message}")
    end

    it "returns in case there are no records to fetch" do
      allow(response).to receive(:[]).and_return 0

      expect(subject).to eq("no records to fetch")
    end

    it "enqueues the InitialDataFetchJob at least once" do
      expect(InitialDataFetchJob).to receive(:perform_async).at_least(:once)

      subject
    end
  end
end
