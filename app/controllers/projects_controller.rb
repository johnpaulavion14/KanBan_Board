class ProjectsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rocks = Rock.all.order("created_at asc")
    @users = User.all.pluck(:email)

  end

  def create_rocks
    start_date = Date.parse params[:start] 
    finish_date = Date.parse params[:finish] 
    duration = (finish_date - start_date).to_i
    respond_to do |format|
      if Rock.create(rock_params)
        format.html { redirect_to view_projects_path, notice: "You have successfully create a new project" }
        format.html { redirect_to request.referrer, notice: "User was successfully WHATEVER." }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_rocks
    respond_to do |format|
      if Rock.find(params[:id]).update(rock_params)
        format.html { redirect_to view_projects_path, notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_rocks
    respond_to do |format|
      if Rock.find(params[:id]).destroy
        format.html { redirect_to view_projects_path, notice: "You have successfully deleted you rock" }
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
