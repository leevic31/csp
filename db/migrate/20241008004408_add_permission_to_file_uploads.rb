class AddPermissionToFileUploads < ActiveRecord::Migration[7.1]
  def change
    add_column :file_uploads, :permission, :string
  end
end
