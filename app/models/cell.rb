class Cell < ActiveRecord::Base
  belongs_to :image
  belongs_to :experiment
  belongs_to :path
  has_many :coordinates
  
  attr_accessible :image, :experiment, :path
end
