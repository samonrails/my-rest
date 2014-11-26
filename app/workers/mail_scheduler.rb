# Scheduled mail to be send to the users created by Admin

class MailScheduler
  include Sidekiq::Worker

  def perform(user_id, temporary_password, method)
    user = User.find(user_id)
    Notifier.send_welcome_email_to_created_user(user, temporary_password).deliver
  end
end
