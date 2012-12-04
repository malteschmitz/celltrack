# == Schema Information
#
# Table name: paths
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  tree_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  import_id     :integer
#
# == Description
#
# A path is a sequence of cells over several images and therefore rather 
# corresponds to a biological entity. In contrast to biology the existence of
# a path ends with the cleavage of the cell and two new paths form. If the
# observed object moves outside of the image, the path also ends. A path begins
# 1. with the cleavage of the 'mother cell', 
# 2. if the cell moves into the image coming from the edge or 
# 3. if the cell was initially there in the first image.
# 
# == Associations
#
# * A certain path belongs to exactly one experiment, in which the corresponding 
#   data were obtained.
# * A certain path belongs to exactly one tree, in which this path is a part of.
# * A certain path has a non-empty set of cells. These observations over several 
#   images actually 'form' this path.
# * A certain path can have several predecessors, i.e. one or more paths, which
#   this path was originated from.
# * A certain path can have several successors, i.e. one or more paths, which
#   are originated from this path.

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
