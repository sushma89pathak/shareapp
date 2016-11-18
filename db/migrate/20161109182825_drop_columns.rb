class DropColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :uploads, :resource_type
    remove_column :uploads, :resource_id
  end
end
