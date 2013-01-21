# == Schema Information
#
# Table name: experiments
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :text
#  import_progress :string
#  import_done     :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
# * A certain experiment has a set of pictures. These contain mainly the
#   filename of the pictures associated to an image.
# * A certain experiment has a set of trees. These describe the developments of 
#   all biological entities, which has been observed in this experiment.
# * A certain experiment has a set of paths. These actually 'form' the single
#   trees.

class Experiment < ActiveRecord::Base
  has_many :cells
  has_many :images
  has_many :trees
  has_many :paths
  has_many :pictures

  attr_accessible :description, :name

  validates :name, :presence => true
  
  def import_progress_percent
    unless import_progress.blank?
      p = import_progress.split('/')
      return p.first.to_i.to_f * 100 / p.second.to_i if p.length == 2
    end
    0
  end
  
  before_destroy do |record|
    # delete cells, images, trees and pictures without any callbacks
    [Cell, Image, Tree, Picture].each do |klass|
      klass.delete_all "experiment_id = #{record.id}"
    end
    # destroy paths with callback to delete entries in join table, too
    Path.destroy_all "experiment_id = #{record.id}"
  end
  
  before_create do |record|
    record.import_progress = 'not yet started' unless record.import_progress
  end
  
  def as_json(options={})
    super(options.merge(:methods => [:import_progress_percent]))
  end
end
