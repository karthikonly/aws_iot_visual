class ConfigurationController < ApplicationController

  skip_before_action :verify_authenticity_token

  def get
    config = JSON.parse(File.read("#{Rails.root.to_s}/config.json"))
    serial_number = params[:serial_number]
    activation = Activation.where('provisioned.accb': serial_number).first
    unless activation
      activation = Activation.new({provisioned: {accb: serial_number}})
      activation.save!
    end
    comm_settings = config['comm_settings']
    comm_settings['site_id'] = activation.siteid
    comm_settings['mqtt_command_stream'] = "gateways/command-stream/#{serial_number}"
    comm_settings['mqtt_response_stream'] = "gateways/response-stream/#{serial_number}"
    comm_settings['mqtt_live_stream'] = "gateways/live-stream/#{serial_number}"
    render json: config
  end
end
