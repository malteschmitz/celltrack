# == Schema Information
#
# Table name: experiments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Experiment < ActiveRecord::Base
  has_many :cells
  has_many :images
  has_many :coordinates
  has_many :trees
  has_many :paths

  attr_accessible :description, :name
end
