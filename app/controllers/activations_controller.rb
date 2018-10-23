class ActivationsController < ApplicationController
  def get
    render json: Activation.all
  end

  def create
  end

  def update
  end
end
