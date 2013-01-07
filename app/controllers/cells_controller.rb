# -*- encoding : utf-8 -*-
class CellsController < ApplicationController
  def show
    respond_with(@cell = Cell.find(params[:id]))
  end
end
