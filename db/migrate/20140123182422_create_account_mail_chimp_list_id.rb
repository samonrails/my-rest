class CreateAccountMailChimpListId < ActiveRecord::Migration
  def up
    create_table :account_email_lists do |t|
      t.belongs_to  :account
      t.string      :list_id
    end
  end

  def down
  end
end
