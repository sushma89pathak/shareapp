class AddFolderIdToUploads < ActiveRecord::Migration[5.0]
  def change
    add_column :uploads, :folder_id, :integer
    add_index :uploads, :folder_id
  end
end
