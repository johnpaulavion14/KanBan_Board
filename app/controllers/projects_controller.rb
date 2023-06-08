class ProjectsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rocks = current_user.rocks.order("created_at asc")
    @milestones = Milestone.all.order("created_at asc")
    @users = User.all.pluck(:email)
    @all_users = User.all
   
  end

  def allprojects
    User.all.each do |user|
      if user.admin == true || user.host == true || current_user.email == "jpbocatija@cem.com"
        @rocks = Rock.all.order("created_at asc")
        @milestones = Milestone.all.order("created_at asc")
        @users = User.all.pluck(:email)
        @all_users = User.all
      end
    end
  end
  
  # Rock
  def create_rocks
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)

    respond_to do |format|
      if current_user.rocks.create(rock_params)
        current_user.rocks.last.update(assigned:@assigned_array)
        format.html { redirect_to view_projects_path(), notice: "You have successfully create a new project" }
      else
        redirect_to view_projects_path
      end
    end
  end

  def update_rocks  
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)
    respond_to do |format|
      if current_user.rocks.find(params[:id]).update(rock_params)
        current_user.rocks.find(params[:id]).update(assigned:@assigned_array)
        format.html { redirect_to view_projects_path, notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_rocks
    current_user.rocks.find(params[:id]).milestones.destroy_all
    respond_to do |format|
      if current_user.rocks.find(params[:id]).destroy
        format.html { redirect_to view_projects_path, notice: "You have successfully deleted you rock" }
      else
        redirect_to view_projects_path
      end
    end
  end

  # Milestones
  def create_milestones
    @milestone = current_user.rocks.find(params[:rock_id]).milestones.new(milestone_params)
    @assigned = params[:assigned].reject(&:empty?)
    respond_to do |format|
      if @milestone.save
        current_user.rocks.find(params[:rock_id]).milestones.update(assigned:@assigned)
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully create a new milestone" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_milestones
    @milestone = current_user.rocks.find(params[:rock_id]).milestones.find(params[:id])
    @assigned = params[:assigned].reject(&:empty?)
    respond_to do |format|
      if @milestone.update(milestone_params)
        @milestone.update(assigned:@assigned)
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_milestones
    @milestone = current_user.rocks.find(params[:rock_id]).milestones.find(params[:id])
    respond_to do |format|
      if @milestone.destroy
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully deleted you milestone" }
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
