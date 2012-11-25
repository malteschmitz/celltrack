class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :experiment
      t.string :filename

      t.timestamps
    end
    add_index :images, :experiment_id
  end
end
