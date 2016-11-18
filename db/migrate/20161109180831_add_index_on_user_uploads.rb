class AddIndexOnUserUploads < ActiveRecord::Migration[5.0]
  def change
    remove_column :uploads, :uploaded_by
    add_column :uploads, :user_id, :integer
    add_index :uploads, :user_id
  end
end
