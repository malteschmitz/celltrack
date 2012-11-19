class Cell < ActiveRecord::Base
  belongs_to :image
  belongs_to :experiment
  # attr_accessible :title, :body
end
