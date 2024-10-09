class AddPermissionToFolders < ActiveRecord::Migration[7.1]
  def change
    add_column :folders, :permission, :string
  end
end
