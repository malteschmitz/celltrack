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

class Coordinate < ActiveRecord::Base
  belongs_to :cell
  belongs_to :image
  belongs_to :experiment

  attr_accessible :cell, :image, :experiment, :x, :y
end
