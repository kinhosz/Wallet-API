class Users::ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user.as_json(only: [:name, :email])
  end
end
