class DropCols < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :label
    add_column :uploads, :label, :string
  end
end
