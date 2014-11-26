require "spec_helper"

describe CateringReportMailer do
  let(:user) { mock_model(User, first_name: 'Dave',last_name: 'bremenr', email: 'dave.bremenr2@gcatering_mail.com') }
  let(:event) { create :catering_event }
  
  describe 'catering_schedule_preview' do
    let(:catering_mail) { CateringReportMailer.catering_schedule_preview(user, "Dave", "david.bremner@fooda.com", "Test") }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      catering_mail.subject.should == "Fooda Report - Catering Schedule Preview"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      catering_mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      catering_mail.from.should == ['snappea@fooda.com']
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @user_name' do
      catering_mail.body.encoded.should match("Dave")
    end

    # Good Example
    #ensure that the @confirmation_url variable appears in the email body
    # it 'assigns @confirmation_url' do
    #   catering_mail.body.encoded.should match("http://aplication_url/#{user.id}/confirmation")
    # end
  end

  describe 'end_of_day_sales_report' do
    let(:sales_mail) { CateringReportMailer.end_of_day_sales_report(user, "Bob", "david.bremner@fooda.com", "Test") }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      sales_mail.subject.should == "Fooda Report - End of Day Sales"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      sales_mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      sales_mail.from.should == ['snappea@fooda.com']
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @user_name' do
      sales_mail.body.encoded.should match("Bob")
    end

    # Good Example
    #ensure that the @confirmation_url variable appears in the email body
    # it 'assigns @confirmation_url' do
    #   catering_mail.body.encoded.should match("http://aplication_url/#{user.id}/confirmation")
    # end
  end
end
