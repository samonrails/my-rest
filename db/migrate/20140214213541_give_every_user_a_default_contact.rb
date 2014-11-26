class GiveEveryUserADefaultContact < ActiveRecord::Migration
  def up
    @user = User.find_by_email "mailto:jbarone@backstopsolutions.com"
    if @user
      @user.skip_reconfirmation!
      @user.email = "jbarone@backstopsolutions.com"
      @user.save
      @user.create_self_contact
    end

    User.all.map do |u|
      begin
        if u.default_contact_id.nil?
          if u.contacts.any?
            u.default_contact_id = u.contacts.first.id
            u.save
          else
            u.create_self_contact
          end
        end
      rescue => e
        puts "Error updating user: #{u.id}. Exception thrown: #{e}"
      end
    end
  end

  def down
  end
end
