# == Schema Information
#
# Table name: paths
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  tree_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Path < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :tree
  has_many :cells
  has_and_belongs_to_many :pred_paths,
                          :class_name => 'Path',
                          :join_table => 'paths_paths',
                          :foreign_key => 'succ_path_id',
                          :association_foreign_key => 'pred_path_id'
  has_and_belongs_to_many :succ_paths,
                          :class_name => 'Path',
                          :join_table => 'paths_paths',
                          :foreign_key => 'pred_path_id',
                          :association_foreign_key => 'succ_path_id'
  
  attr_accessible :experiment, :tree
end
