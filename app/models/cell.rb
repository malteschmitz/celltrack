# == Schema Information
#
# Table name: cells
#
#  id            :integer          not null, primary key
#  image_id      :integer
#  experiment_id :integer
#  path_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# A cell is a single observation in a particular image.
# 
# A certain cell belongs to exactly one experiment, in which the corresponding 
# data were obtained.
# A certain cell belongs to exactly one image, in which this cell has been
# observed.
# A certain cell belongs to exactly one path, in which this cell is part of the
# development of the observed biological entity.
# A certain cell has a non-empty set of coordinates, which describe this cell
# in a particular image.

class Cell < ActiveRecord::Base
  belongs_to :image
  belongs_to :experiment
  belongs_to :path
  has_many :coordinates
  
  attr_accessible :image, :experiment, :path
end
