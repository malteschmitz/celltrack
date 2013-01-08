class AddIndicesToPictures < ActiveRecord::Migration
  def change
    add_index :pictures, :image_id
    add_index :pictures, :experiment_id
  end
end
