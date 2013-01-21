class AddPrgressAndDoneToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :import_progress, :string
    add_column :experiments, :import_done, :boolean 
  end
end
