class CreatePathJoinTable < ActiveRecord::Migration
  def change
    create_table :paths_paths do |t|
      t.references :pred_path
      t.references :succ_path
    end
    add_index :paths_paths, :pred_path_id
    add_index :paths_paths, :succ_path_id
  end
end
