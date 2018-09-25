class TsNamesController < ApplicationController
  def index
    @ts_names = TsName.only(:id, :name)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ts_names }
    end
  end
end
