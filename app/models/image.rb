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

class Image < ActiveRecord::Base
  belongs_to :experiment
  has_many :cells
  has_many :coordinates

  attr_accessible :experiment, :filename
end
