class ProjectsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rocks = Rock.all

  end

  def create_rocks
    respond_to do |format|
      if Rock.create(rock_params)
        format.html { redirect_to view_projects_path, notice: "You have successfully create a new project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  private

  def rock_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :status, :remarks)
  end


end
