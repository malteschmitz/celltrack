class RemoveImportId < ActiveRecord::Migration
  def up
    remove_column :paths, :import_id
  end

  def down
    add_column :paths, :import_id, :integer
  end
end
