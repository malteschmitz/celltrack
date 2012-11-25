class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.references :cell
      t.references :image
      t.references :experiment
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :coordinates, :cell_id
    add_index :coordinates, :image_id
    add_index :coordinates, :experiment_id
  end
end
