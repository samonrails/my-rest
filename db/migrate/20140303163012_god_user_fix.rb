class GodUserFix < ActiveRecord::Migration
  def up
    if Event.where(created_by_id: 0).any?
      u = User.where(email: "foodadev@fooda.com").first_or_initialize
      u.first_name =  "System"
      u.last_name = "User"
      u.utility_account = true
      u.password= "iloverandompasswordsbutthisonewilldo"
      u.save!
      u.confirm!
      Event.where(created_by_id: 0).update_all(created_by_id: u.id)
    end
  end

  def down
    u = User.where(email: "foodadev@fooda.com").first
    Event.where(created_by_id: u.id).update_all(created_by_id: 0)
  end
end
