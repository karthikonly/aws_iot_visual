class ActivationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def get
    render json: Activation.nin(stage: [0, nil]).only(:siteid, :name).to_json(except: :_id)
  end

  def create
    activation = Activation.new
    activation['name'] = params['name']
    activation['location'] = Location.new params.require(:location).permit(:city, :country, :state, :zipcode, :address)
    activation.stage = 1
    activation.save!
    render json: {siteid: activation.siteid}
  end

  def update
    activation = {}
    activation['name'] = params['name'] if params['name']
    if params['location']
      params.require(:location).permit(:city, :country, :state, :zipcode, :address).each do |key, value|
        activation["location.#{key}"] = value
      end
    end
    Activation.where(siteid: params['id']).set(activation)
    render json: {}
  end

  def delete
    Activation.where(siteid: params['id']).delete
    render json: {}
  end

  def inventory
    count = {}
    Activation::TYPES.each do |type|
      count["provisioned_count.#{type}"] = params[type] if params[type]
    end
    Activation.where(siteid: params['id']).set(count)
    render json: {}
  end

  def serial
    serial = {}
    serial["provisioned.#{params['type']}"] = params['serial']
    Activation.where(siteid: params['id']).add_to_set(serial)
    render json: {}
  end

  def delete_serial
    Activation.where(siteid: params['id']).delete
    render json: {}
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
