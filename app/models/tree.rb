# == Schema Information
#
# Table name: trees
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  root_path_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# == Description
#
# A tree decribes, which paths belong to the same biological entity. Since the 
# existence of a path ends with cleavage, the two possible successor paths 
# belong to the same biological entity.
# 
# == Associations
#
# * A certain tree belongs to exactly one experiment, in which the corresponding 
#   data were obtained.
# * A certain tree belongs to exactly one root tree, in which the existence of a
#   biological entity has begun.
# * A certain tree has a non-empty set of paths, which actually 'form' this
#   tree.

class Tree < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :root_path, :class_name => 'Path'
  has_many :paths
  
  attr_accessible :experiment, :root_path
end
