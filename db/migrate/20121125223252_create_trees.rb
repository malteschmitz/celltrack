class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.references :experiment
      t.references :root_path

      t.timestamps
    end
    add_index :trees, :experiment_id
    add_index :trees, :root_path_id
  end
end
