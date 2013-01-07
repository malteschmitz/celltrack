# -*- encoding : utf-8 -*-
class ImagesController < ApplicationController
  def show
    respond_with(@image = Image.find(params[:id]))
  end
  
  def goto
    redirect_to image_url(params[:id])
  end
end
