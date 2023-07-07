class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @project_workspaces = ProjectWorkspace.order(created_at: :asc)
    @users = User.all.pluck(:email)
  end
  
  def index
    @rocks = []
    rocks = Rock.all.order(start: :asc)
    rocks.all.each do |rock|
      if rock.assigned.include? current_user.email
        @rocks.push(rock)
      end
    end

    @milestones = Milestone.all.order(start: :asc)
    @users = User.all.pluck(:email)
    @all_users = User.all

  end

  def allprojects
    User.all.each do |user|
      if user.admin == true || user.host == true || current_user.email == "jpbocatija@cem-inc.org.ph"
        @rocks = Rock.all.order(start: :asc)
        @milestones = Milestone.all.order(start: :asc)
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
    @assigned_array.delete(Rock.find(params[:id]).user.email)
    @assigned_array.insert(0, Rock.find(params[:id]).user.email)
    respond_to do |format|
      if Rock.find(params[:id]).update(rock_params)
        Rock.find(params[:id]).update(assigned:@assigned_array)
        format.html { redirect_to view_projects_path, notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_rocks
    # delete rock messages
    current_user.rocks.find(params[:id]).rockmessages.destroy_all
    # delete milestone messages
    allmilestone = current_user.rocks.find(params[:id]).milestones
    allmilestone.each do |milestone|
      milestone.messages.destroy_all
    end
    # delete milestones
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
    @milestone = Rock.find(params[:rock_id]).milestones.new(milestone_params)
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)
    respond_to do |format|
      if @milestone.save
        Rock.find(params[:rock_id]).milestones.last.update(assigned:@assigned_array)
        if params[:complete] == "100"
          Rock.find(params[:rock_id]).milestones.last.update(date_completed:Date.today)
        end
        if Rock.find(params[:rock_id]).milestones.average(:complete) == 100
          Rock.find(params[:rock_id]).update(date_completed:Date.today)
        else
          Rock.find(params[:rock_id]).update(date_completed:"")
        end
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully create a new milestone" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_milestones
    @milestone = Rock.find(params[:rock_id]).milestones.find(params[:id])
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(@milestone.user.email)
    @assigned_array.insert(0, @milestone.user.email)
    respond_to do |format|
      if @milestone.update(milestone_params)
        @milestone.update(assigned:@assigned_array)
        if params[:complete] == "100"
          @milestone.update(date_completed:Date.today)
        else
          @milestone.update(date_completed:"")
        end
        if Rock.find(params[:rock_id]).milestones.average(:complete) == 100
          Rock.find(params[:rock_id]).update(date_completed:Date.today)
        else
          Rock.find(params[:rock_id]).update(date_completed:"")
        end
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_milestones
    @milestone = current_user.milestones.find(params[:id])
    # delete milestone messages
    @milestone.messages.destroy_all
    respond_to do |format|
      if @milestone.destroy
        if Rock.find(params[:rock_id]).milestones.average(:complete) == 100
          Rock.find(params[:rock_id]).update(date_completed:Date.today)
        end
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully deleted you milestone" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id]})
      end
    end
  end

  # Milestone Messages
  def create_message
    respond_to do |format|
      if Milestone.find(params[:milestone_id]).messages.create(message_params)
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully create a new message" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id],milestone_id: params[:milestone_id] })
      end
    end
  end

  def update_message
    respond_to do |format|
      if Milestone.find(params[:milestone_id]).messages.find(params[:id]).update(message_params)
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully updated a new message" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id],milestone_id: params[:milestone_id]})
      end
    end
  end

  def delete_message
    @message = Milestone.find(params[:milestone_id]).messages.find(params[:id])
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully deleted your message" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id],milestone_id: params[:milestone_id]})
      end
    end
  end
  # Rock Messages
  def create_rockmessage
    respond_to do |format|
      if Rock.find(params[:rock_id]).rockmessages.create(message_params)
        format.html { redirect_to view_projects_path({rock_m_id: params[:rock_id]}), notice: "You have successfully create a new message" }
      else
        redirect_to view_projects_path({rock_m_id: params[:rock_id]})
      end
    end
  end

  def update_rockmessage
    respond_to do |format|
      if Rock.find(params[:rock_id]).rockmessages.find(params[:id]).update(message_params)
        format.html { redirect_to view_projects_path({rock_m_id: params[:rock_id]}), notice: "You have successfully updated a new message" }
      else
        redirect_to view_projects_path({rock_m_id: params[:rock_id]})
      end
    end
  end

  def delete_rockmessage
    @message = Rock.find(params[:rock_id]).rockmessages.find(params[:id])
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to view_projects_path({rock_m_id: params[:rock_id]}), notice: "You have successfully deleted your message" }
      else
        redirect_to view_projects_path({rock_m_id: params[:rock_id]})
      end
    end
  end

  private

  def rock_params
    params.permit(:task_name, :start, :finish, :assigned, :remarks, :output, :date_completed)
  end

  def milestone_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :remarks,:user_id, :output, :date_completed)
  end

  def message_params
    params.permit(:message, :first_name, :last_name, :time)
  end

end
