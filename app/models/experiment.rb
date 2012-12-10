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
# == Description
#
# An experiment is a certain 'cell tracking' observation experiment, in which
# particular data is obtained, e.g. images.
# 
# == Associations
#
# * A certain experiment has a set of cells. These are the observations over 
#   several images.
# * A certain experiment has a set of images. These are the main data, which is
#   collected during an experiment.
# * A certain experiment has a set of coordinates. These describe, for a certain
#   image, which cell can be seen at which position.
# * A certain experiment has a set of trees. These describe the developments of 
#   all biological entities, which has been observed in this experiment.
# * A certain experiment has a set of paths. These actually 'form' the single
#   trees.

class Experiment < ActiveRecord::Base
  has_many :cells
  has_many :images
  has_many :coordinates
  has_many :trees
  has_many :paths

  attr_accessible :description, :name
  
  def import(uploaded_file)
    Zip::ZipFile::open(uploaded_file.tempfile) do |zf|
      debugger
      # zf.select {|f| f.directory?}
    end
  end
end
