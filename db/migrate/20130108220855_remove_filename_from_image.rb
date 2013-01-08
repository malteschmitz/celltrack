class RemoveFilenameFromImage < ActiveRecord::Migration
  def up
    remove_column :images, :filename
  end

  def down
    add_column :images, :filename, :string
  end
end
