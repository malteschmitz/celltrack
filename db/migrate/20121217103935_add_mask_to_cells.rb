class AddMaskToCells < ActiveRecord::Migration
  def change
    add_column :cells, :mask, :binary
  end
end
