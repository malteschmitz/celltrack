# == Schema Information
#
# Table name: pictures
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  filename      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# == Description
# 
# A picture contains the filename of a real photography. The filename is
# relative to public/experiments
# 
# == Associations
#
# * A certain picture belongs to exactly one image. The image contains all
#   information regarding the real data. Pictures exists only because one
#   image can consists of many files.
# * A certain picture belongs to exactly one experiment, in which the
#   corresponding data were obtained.

class Picture < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :image

  attr_accessible :experiment, :filename
end
