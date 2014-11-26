class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :identity, polymorphic: true
      t.string :digest
      t.datetime :accessed_at
      t.datetime :expires_at
      t.string :data

      t.timestamps
    end
    add_index :tokens, :identity_id
  end
end
