class AddImportIdToPath < ActiveRecord::Migration
  def change
    add_column :paths, :import_id, :integer
  end
end
