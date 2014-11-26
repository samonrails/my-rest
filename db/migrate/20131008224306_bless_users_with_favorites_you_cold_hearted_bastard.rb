class BlessUsersWithFavoritesYouColdHeartedBastard < ActiveRecord::Migration
  def change
    create_table :menu_templates_users do |t|
      t.belongs_to :menu_template
      t.belongs_to :user
    end
  end
end
