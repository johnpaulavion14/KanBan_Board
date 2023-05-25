class ProjectsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rocks = Rock.all.order("created_at asc")
    @milestones = Milestone.all.order("created_at asc")
    @users = User.all.pluck(:email)

  end
  
  # Rock
  def create_rocks
    respond_to do |format|
      if Rock.create(rock_params)
        format.html { redirect_to view_projects_path, notice: "You have successfully create a new project" }
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

  # Milestones
  def create_milestones
    @milestone = Rock.find(params[:rock_id]).milestones.new(milestone_params)
    respond_to do |format|
      if @milestone.save
        format.html { redirect_to view_projects_path, notice: "You have successfully create a new milestone" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_milestones
    @milestone = Rock.find(params[:rock_id]).milestones.find(params[:id])
    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to view_projects_path, notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_milestones
    @milestone = Rock.find(params[:rock_id]).milestones.find(params[:id])
    respond_to do |format|
      if @milestone.destroy
        format.html { redirect_to view_projects_path, notice: "You have successfully deleted you milestone" }
      else
        redirect_to view_projects_path
      end
    end
  end

  private

  def rock_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :status, :remarks)
  end

  def milestone_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :status, :remarks)
  end


end
