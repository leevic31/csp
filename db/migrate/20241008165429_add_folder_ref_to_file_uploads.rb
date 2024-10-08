class AddFolderRefToFileUploads < ActiveRecord::Migration[7.1]
  def change
    add_reference :file_uploads, :folder, null: false, foreign_key: true
  end
end
