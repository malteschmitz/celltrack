class Coordinate < ActiveRecord::Base
  belongs_to :cell
  belongs_to :image
  belongs_to :experiment

  attr_accessible :cell, :image, :experiment, :x, :y
end
