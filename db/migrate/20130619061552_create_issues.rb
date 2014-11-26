class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.string :priority
      t.references :subject, polymorphic: true
      t.integer :assignee_id
      t.integer :assigner_id
      t.datetime :open_date
      t.datetime :due_date
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
