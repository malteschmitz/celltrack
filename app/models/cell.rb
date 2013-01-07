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
# == Description
# 
# A cell is a single observation in a particular image.
# 
# == Associations
#
# * A certain cell belongs to exactly one experiment, in which the corresponding 
#   data were obtained.
# * A certain cell belongs to exactly one image, in which this cell has been
#   observed.
# * A certain cell belongs to exactly one path, in which this cell is part of
#   the development of the observed biological entity.
# * A certain cell has a binary mask, which encodes the coordinates of the
#   cell in its image, a top left coordinate, where this mask starts
#   and a width and a height which determines the size of the mask.
#   Additionally a center coordinate is stored for easier navigation.

class Cell < ActiveRecord::Base
  belongs_to :image
  belongs_to :experiment
  belongs_to :path
  
  attr_accessible :image, :experiment, :path, :mask, :top, :left, :center_x,
    :center_y, :width, :height
end
