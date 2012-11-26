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

class Tree < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :root_path, :class_name => 'Path'
  has_many :paths
  
  attr_accessible :experiment, :root_path
end
