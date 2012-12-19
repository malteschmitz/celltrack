class RemoveIdFromPathsPaths < ActiveRecord::Migration
  def up
    remove_column :paths_paths, :id
  end

  def down
    add_column :paths_paths, :id, :integer, :primary_key
  end
end
