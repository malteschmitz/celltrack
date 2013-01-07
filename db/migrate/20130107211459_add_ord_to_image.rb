class AddOrdToImage < ActiveRecord::Migration
  def change
    add_column :images, :ord, :integer
  end
end
