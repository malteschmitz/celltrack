# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  ord           :integer
#  width         :integer
#  height        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# == Description
# 
# An image is a two-dimensional matrix respresentation, which assigns a cell
# to every pixel of a certain microscopy photograph. An image refers to a
# specific point in time. Images are ordered using the ord column. The
# dimension of the image in pixels is stored in the attributes with and height.
# Every picture of this image has to have this dimension (or at least the
# same aspect ratio as this dimension). 
# 
# == Associations
#
# * A certain image belongs to exactly one experiment, in which the
#   corresponding data were obtained.
# * A certain image has many cells, which can be observed in this image.
# * A certain image has many pictures, which contain the filename of the
#   actual image files. All pictures of one image show the same cells at the
#   same time. They may differ e.g. in the contrast.

class Image < ActiveRecord::Base
  belongs_to :experiment
  has_many :cells
  has_many :pictures

  attr_accessible :experiment, :filename, :ord
  
  def as_json(options={})
    super(options.merge(:methods => [:cells, :pictures]))
  end
end
