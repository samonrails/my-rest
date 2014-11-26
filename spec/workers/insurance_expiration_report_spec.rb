require "spec_helper"

describe InsuranceExpirationReport do
  describe '#perform' do
    it "should queue an email" do
      expect {
        InsuranceExpirationReport.perform_async("John Doe", "doe@example.com", "whydidyoucallthismethod")
      }.to change(InsuranceExpirationReport.jobs, :size).by(1)
    end
  end
end

