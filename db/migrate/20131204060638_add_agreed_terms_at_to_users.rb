class AddAgreedTermsAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agreed_terms_at, :datetime
  end
end
