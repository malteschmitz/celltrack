# -*- encoding : utf-8 -*-
class ExperimentsController < ApplicationController
  before_filter :compute_paths, :only => [:new, :create]

  def index
    respond_with(@experiments = Experiment.all)
  end
  
  def show
    respond_with(@experiment = Experiment.find(params[:id]))
  end
  
  def new
    respond_with(@experiment = Experiment.new)
  end
  
  def edit
    respond_with(@experiment = Experiment.find(params[:id]))
  end
  
  def create
    # create new experiment object
    @experiment = Experiment.new(params[:experiment])
    # validate experiment explicitly
    @experiment.valid?
    
    path = import_path
    unless path
      @experiment.errors[:base] << 'Neither a file nor folder containing the data selected'
    end

    picture_paths = params[:picture_paths]
    
    if picture_paths.blank?
      @experiment.errors[:base] << 'No folder containing the pictures selected'
    end

    if @experiment.errors.empty? and @experiment.save
      flash[:notice] = "Experiment “#{@experiment.name}” was successfully created."
      if params[:delayed_job]
        parser = ExperimentParser.delay
      else
        parser = ExperimentParser
      end
      parser.parseCellExperiment(@experiment, path, picture_paths)
    end
    respond_with(@experiment)
  end
  
  def update
    @experiment = Experiment.find(params[:id])
    if @experiment.update_attributes(params[:experiment])
      flash[:notice] = "Experiment was successfully renamed to “#{@experiment.name}”."
    end
    respond_with(@experiment)
  end
  
  def destroy
    @experiment = Experiment.find(params[:id])
    if @experiment.destroy
      flash[:notice] = "Experiment “#{@experiment.name}” was successfully deleted."
    end
    respond_with(@experiment)
  end
  
  private

  def import_path  
    if not params[:import_file].blank?
      params[:import_file]
    elsif not params[:upload_file].blank?
      upload_file = params[:upload_file]
      org = upload_file.original_filename
      ext = File.extname(org)
      base = File.basename(org, ext)
      file = org
      i = 0
      while File.exists?(IMPORT_ROOT.join(file))
        i += 1        
        file = base + '_' + i.to_s + ext
      end
      FileUtils.cp upload_file.tempfile, IMPORT_ROOT.join(file)
      file
    end
  end
  
  def compute_paths
    @import_files = Dir.entries(IMPORT_ROOT).select do |path|
      path != '.' and path != '..' and
        ['', '.zip'].include?(File.extname(path))
    end
  
    @picture_paths = Dir.entries(PICTURE_ROOT).select do |path|
      path != '.' and path != '..' and
        File.directory?(PICTURE_ROOT.join(path))
    end
  end
end
