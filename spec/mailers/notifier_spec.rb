require "spec_helper"

describe Notifier do

  describe 'send mail to assignee' do

    let(:issue) { create :issue }
    let(:issue_mail) { Notifier.send_issue_to_assignee(issue) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      issue_mail.subject.should == "[Fooda] You have been assigned a new issue."
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      issue_mail.to.should == [issue.assignee.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      issue_mail.from.should == ['snappea@fooda.com']
    end

  end

end
