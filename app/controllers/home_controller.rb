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
end
