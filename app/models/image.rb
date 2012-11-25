class Image < ActiveRecord::Base
  belongs_to :experiment
  has_many :cells
  has_many :coordinates

  attr_accessible :experiment, :filename
end
