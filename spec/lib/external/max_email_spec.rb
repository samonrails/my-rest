require "spec_helper"

describe MaxEmail do 
  context "fax number creation " do 
    it "should return a correct email address" do 
      MaxEmail.email_address("12345678901").should == "12345678901@maxemailsend.com"
    end

    it "with an incorrect fax number" do
      lambda { MaxEmail.email_address("1234567890") }.should raise_error(StandardError, "Incorrect 11 digit fax number: 1234567890")
    end

  end 

  it "should buffer a s3 file in memory" do
    # 15254 is the size of the test_documetn djb made and uploaded to s3.
    MaxEmail.s3_attachment("test_document.pdf").size.should == 15254
  end
end
