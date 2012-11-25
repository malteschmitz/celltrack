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

class Cell < ActiveRecord::Base
  belongs_to :image
  belongs_to :experiment
  belongs_to :path
  has_many :coordinates
  
  attr_accessible :image, :experiment, :path
end
