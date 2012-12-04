# == Schema Information
#
# Table name: coordinates
#
#  id            :integer          not null, primary key
#  cell_id       :integer
#  image_id      :integer
#  experiment_id :integer
#  x             :integer
#  y             :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# == Description
#
# A coordinate describes for a certain image, at which position a particular
# cell can be found.
#  
# == Associations
#
# * A certain coordinate belongs to exactly one experiment, in which the 
#   corresponding data were obtained.
# * A certain coordinate belongs to exactly one image, in which this coordinate
#   describes the position of a certain cell.
# * A certain coordinate belongs to exactly one cell, which this coordinate
#   describes in a certain image.

class Coordinate < ActiveRecord::Base
  belongs_to :cell
  belongs_to :image
  belongs_to :experiment

  attr_accessible :cell, :image, :experiment, :x, :y
end
