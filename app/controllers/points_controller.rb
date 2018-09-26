class PointsController < ApplicationController
  def index
    if params[:serial_number] && params[:ts_name]
      ts = TsName.find_by(name: params[:ts_name])
      gw = Gateway.find_by(serial_number: params[:serial_number])
      series_id = Series.find_by(gateway_id: gw.id, ts_name_id: ts.id).id
    else
      series_id = params[:series_id]
    end
    @points = ChartLine.where(series_id: series_id).order_by(time: :asc)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @points.map {|x| [x.ticks, x.value]} }
    end
  end
end
