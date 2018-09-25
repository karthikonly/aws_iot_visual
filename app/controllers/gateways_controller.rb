class GatewaysController < ApplicationController
  def index
    @gateways = Gateway.only(:id, :serial_number)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gateways }
    end
  end
end
