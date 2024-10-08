class CreateFileShares < ActiveRecord::Migration[7.1]
  def change
    create_table :file_shares do |t|
      t.references :file_upload, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
