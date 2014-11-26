class Notifier < ActionMailer::Base
  default from: "snappea@fooda.com"

  def send_issue_to_assignee(issue)
    @issue = issue
    @assignee = issue.assignee
    @assigner = issue.assigner
    @subject = issue.subject
    braintree_error = (issue.title == "Braintree Transaction Failed")
    recipients = braintree_error ? [@assignee.email, 'accounting@fooda.com'] : @assignee.email

    mail(to: recipients, subject: "[Fooda] You have been assigned a new issue.")
  end
  
  def send_welcome_email_to_created_user(user, temporary_password)
    @user = user
    @temporary_password = temporary_password
    @images_link = "http://#{SnapPea::Application.config.action_mailer.default_url_options[:host]}/template_images/"
    mail(to: @user.email, from: "info@fooda.com", subject: "Your Fooda account was created!")
  end

  def send_feedback_email(event)
    Rails.logger.warn "A Event Feedback Email was triggered and sent to Dave not the client."
    @event = event
    product_type = Product.find_parent(@event.product)
    subject = product_type == "managed_services" ? "Rate Your Catering Event" : "Fooda Catering - Event Feedback"
    @contact = event.contact
    @tokens = event.active_tokens.order('data')
    #Hot fix to stop sending bad code to users.
    mail(to: "david.bremner@fooda.com", from: "info@fooda.com", subject: subject)
    # mail(to: @contact.email, from: "info@fooda.com", subject: subject)
  end

  def send_transaction_failure_report(title, description)
    subject = title
    @body = description
    mail(to: 'accounting@fooda.com', from: "info@fooda.com", subject: subject)
  end

end
