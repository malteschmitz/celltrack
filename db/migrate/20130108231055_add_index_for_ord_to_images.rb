class AddIndexForOrdToImages < ActiveRecord::Migration
  def change
    add_index :images, :ord
  end
end
