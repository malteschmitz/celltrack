class AddCoordinatesToCell < ActiveRecord::Migration
  def change
    add_column :cells, :top, :integer
    add_column :cells, :left, :integer
    add_column :cells, :center_x, :integer
    add_column :cells, :center_y, :integer
    add_column :cells, :width, :integer
    add_column :cells, :height, :integer
  end
end
