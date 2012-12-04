# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  filename      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# == Description
# 
# An image is a two-dimensional matrix respresentation, which assigns a cell
# to every pixel of a certain microscopy photograph. 
# 
# == Associations
#
# * A certain image belongs to exactly one experiment, in which the
#   corresponding data were obtained.
# * A certain image has many cells, which can be observed in this image.
# * A certain image has many coordinates, which describe positions of cells in
#   this images.

class Image < ActiveRecord::Base
  belongs_to :experiment
  has_many :cells
  has_many :coordinates

  attr_accessible :experiment, :filename
end
