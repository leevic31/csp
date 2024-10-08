class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.string :action
      t.integer :user_id
      t.string :target_type
      t.integer :target_id

      t.timestamps
    end
  end
end
