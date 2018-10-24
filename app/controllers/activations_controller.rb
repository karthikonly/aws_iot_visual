class ActivationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def get
    render json: Activation.nin(stage: [0, nil]).only(:siteid, :name).to_json(except: :_id)
  end

  def create
    activation = Activation.new()
    activation['name'] = params['name']
    activation['location'] = Location.new params.require(:location).permit(:city, :country, :state, :zipcode, :address)
    activation.stage = 1
    activation.save!
    render json: {siteid: activation.siteid}
  end

  def update
  end

  def inventory

  end

  def serial

  end

  def details
    activation = Activation.where(siteid: params[:id]).without(:created_at, :updated_at).first
    activation['discovered_count'] = {}
    activation.discovered.each do |device, serial|
      activation['discovered_count'][device] = serial.count
    end
    render json: activation.to_json(except: :_id)
  end
end
