# -*- encoding : utf-8 -*-
class ImagesController < ApplicationController
  def show
    respond_with(@image = Image.find(params[:id]))
  end
end
