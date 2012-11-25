class Tree < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :root_path
  has_many :paths
  
  attr_accessible :experiment, :root_path
end
