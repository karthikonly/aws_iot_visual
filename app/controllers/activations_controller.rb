class ActivationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def get
    render json: Activation.nin(stage: [0, nil]).only(:siteid, :name).to_json(except: :_id)
  end

  def create
    activation = Activation.new()
    params['activation'].each do |key, value|
      activation[key] = value
    end
    activation.stage = 1
    activation.save!
    render json: {siteid: activation.siteid}
  end

  def update
  end

  def details
    activation = Activation.where(siteid: params[:id]).only(:name, :siteid, :location, :provisioned, :provisioned_count).first
    render json: activation.to_json(except: :_id)
  end
end
