class AddPermissionToFileShares < ActiveRecord::Migration[7.1]
  def change
    add_column :file_shares, :permission, :string
  end
end
