class SeriesController < ApplicationController
  def index
    @series = Series.includes(:gateway, :ts_name)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @series }
    end
  end
end
