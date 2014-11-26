require "spec_helper"

describe MaxEmail do

  describe 'Send mail to MaxEmail Fax Service' do
    let(:maxemail_fax) { MaxEmailMailer.send_fax("11111111111", "test_document.pdf") }

    it 'renders the subject' do
      maxemail_fax.subject.should == "{NOCOVERPAGE}"
    end
 
    it 'renders the receiver email' do
      maxemail_fax.to.should == ["11111111111@maxemailsend.com"]
    end
 
    it 'renders the sender email' do
      maxemail_fax.from.should == ['info@fooda.com']
    end

    it 'should have an attachment' do
      maxemail_fax.attachments.should have(1).attachment
      attachment = maxemail_fax.attachments[0]
      attachment.filename.should == 'test_document.pdf'
    end
  end

end
