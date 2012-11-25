class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.references :image
      t.references :experiment
      t.references :path

      t.timestamps
    end
    add_index :cells, :image_id
    add_index :cells, :experiment_id
    add_index :cells, :path_id
  end
end
