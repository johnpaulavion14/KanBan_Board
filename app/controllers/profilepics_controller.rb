class ProfilepicsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.profilepics.create(profilepic_params)
    redirect_to dashboard_path()
    
  end

  private

  def profilepic_params
    params.permit(:avatar, :pic)
  end

end