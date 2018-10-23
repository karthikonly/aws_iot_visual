class ActivationsController < ApplicationController
  def get
    render json: Activation.all.only(:siteid, :name).to_json(except: :_id)
  end

  def create
  end

  def update
  end
end
