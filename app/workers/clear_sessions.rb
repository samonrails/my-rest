# To clear all of 

class ClearUserSessions
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    user.clear_sessions
  end
end
