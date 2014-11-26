class ModifySystemUser < ActiveRecord::Migration
  def up
    if User.where(id: 0).any?
      had_system_user = true
      User.find(0).delete
    elsif User.where(utility_account: false).any?
      u = User.where(email: "foodadev@fooda.com").first_or_initialize
      u.first_name =  "System"
      u.last_name = "User"
      u.utility_account = true
      u.password= "iloverandompasswordsbutthisonewilldo"
      u.skip_confirmation!
      u.save!
      if had_system_user
        Event.where(created_by_id: 0).update_all(created_by_id: u.id)
      end
    end
  end

  def down
  end
end
