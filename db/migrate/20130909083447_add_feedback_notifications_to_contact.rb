class AddFeedbackNotificationsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :feedback_notifications, :boolean, default: true
  end
end
