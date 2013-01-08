class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :image
      t.references :experiment
      t.string :filename
      
      t.timestamps
    end
  end
end
