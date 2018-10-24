class HomeController < ApplicationController
  def index
    gon.aws_access_key_id = $aws_access_key_id
    gon.aws_secret_access_key = $aws_secret_access_key
  end

  def activations
    @activations = Activation.all
  end

  def activation
    @activation = Activation.find(params[:id])
    helpers.process_serial_numbers(@activation)
  end

  def new
    @activation = Activation.new
  end

  def create
    @activation = Activation.create(activation_params)
    @activation.stage = 1
    if @activation.save
      redirect_to action: 'activations'
    else
      redirect_to :back
    end
  end

  protected

  def activation_params
    params.require(:activation).permit(:name, :location_address, :location_city, :location_zip, :location_state, provisioned_count: {})
  end
end
