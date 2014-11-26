require "spec_helper"

describe MaxEmailJob do
  describe '#perform' do
    it "should queue an email" do
      expect {
        MaxEmailJob.perform_async(11111111111, "test_document.pdf")
      }.to change(MaxEmailJob.jobs, :size).by(1)
    end
  end
end
