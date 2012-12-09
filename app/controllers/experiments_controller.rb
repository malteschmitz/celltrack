# -*- encoding : utf-8 -*-
class ExperimentsController < ApplicationController
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
    @experiment = Experiment.new(params[:experiment])
    if @experiment.save
      flash[:notice] = "Experiment “#{@experiment.name}” was successfully created."
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
end
