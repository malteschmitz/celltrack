class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.references :experiment
      t.references :tree

      t.timestamps
    end
  end
end
