class Experiment < ActiveRecord::Base
  has_many :cells
  has_many :images
  has_many :coordinates
  has_many :trees
  has_many :paths

  attr_accessible :description, :name
end
