class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @project_workspaces = []
    project_workspaces = ProjectWorkspace.order(created_at: :asc)
    project_workspaces.all.each do |workspace|
      if workspace.assigned.include? current_user.email
        @project_workspaces.push(workspace)
      end
    end
    @users = User.all.order(id: :asc).pluck(:email)
  end
  
  def index
    @rocks = []
    @pw_emails = []
    @ids_array = []
    rocks = ProjectWorkspace.find(params[:pw_id]).rocks.order(finish: :asc).where(archived:false)
    rocks.all.each do |rock|
      if rock.assigned.include? current_user.email
        @rocks.push(rock)
          if !@ids_array.include?(rock.user.id)
            id_value = []
            id_value.push(rock.user.email)
            id_value.push(rock.user.id)
            @pw_emails.push(id_value)
            @ids_array.push(rock.user.id)
          end
        end
    end
    @pw_emails.unshift("all_rocks")

    params_gsub = params[:rocks_owner].gsub(".1","")
    @ids_array.each do |id|
      if params_gsub == id.to_s
        @rocks = []
        user_rocks = ProjectWorkspace.find(params[:pw_id]).rocks.order(finish: :asc).where(user_id: id).where(archived:false)
        user_rocks.each do |rock| 
          if rock.assigned.include? current_user.email
            @rocks.push(rock)
          end
        end
      end
    end
   
    @milestones = Milestone.all.order(start: :asc)
    @submilestones = Submilestone.all.order(start: :asc)
    @sub2milestones = Sub2milestone.all.order(start: :asc)
    @users = ProjectWorkspace.find(params[:pw_id]).assigned
    @all_users = User.all
    @scribe = HostScribe.where('date <= ?',Date.today) == [] ? "" : HostScribe.where('date <= ?',Date.today).order("date asc").last.scribe

  end

  def allprojects
    User.all.each do |user|
      if user.admin == true || user.host == true || current_user.email == "jpbocatija@cem-inc.org.ph"
        @rocks = ProjectWorkspace.find(params[:pw_id]).rocks.order(finish: :asc)
        @pw_emails = []
        @ids_array = []
        assigned_array = ProjectWorkspace.find(params[:pw_id]).assigned
        assigned_array.each do |email| 
          id_value = []
          id_value.push(email)
          id_value.push(User.find_by(email:email).id)
          @pw_emails.push(id_value)
          @ids_array.push(User.find_by(email:email).id)
        end
        @pw_emails.unshift("all_rocks")

        @ids_array.each do |id|
          if params[:rocks_owner] == id.to_s
            @rocks = ProjectWorkspace.find(params[:pw_id]).rocks.order(finish: :asc).where(user_id: id)
          end
        end

        @milestones = Milestone.all.order(start: :asc)
        @submilestones = Submilestone.all.order(start: :asc)
        @sub2milestones = Sub2milestone.all.order(start: :asc)
        @all_users = User.all
      end
    end
  end

  def archived
      @rocks = ProjectWorkspace.find(params[:pw_id]).rocks.order(finish: :asc).where(archived:true)

      @milestones = Milestone.all.order(start: :asc)
      @submilestones = Submilestone.all.order(start: :asc)
      @sub2milestones = Sub2milestone.all.order(start: :asc)
      @all_users = User.all
  end

  def send_archived
    Rock.find(params[:archived_id]).update(archived:true)
    redirect_to view_projects_path
  end

  def return_archived
    Rock.find(params[:archived_id]).update(archived:false)
    redirect_to view_archived_path
  end

  # Rock
  def create_rocks
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)

    respond_to do |format|
      if ProjectWorkspace.find(params[:pw_id]).rocks.create(rock_params)
        ProjectWorkspace.find(params[:pw_id]).rocks.last.update(assigned:@assigned_array)
        if params[:complete] == "100"
          Rock.last.update(date_completed:Date.today)
        end
        format.html { redirect_to view_projects_path, notice: "You have successfully create a new project" }
      else
        redirect_to view_projects_path
      end
    end
  end

  def update_rocks  
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(User.find(params[:user_id]).email)
    @assigned_array.insert(0, User.find(params[:user_id]).email)
    respond_to do |format|
      if Rock.find(params[:id]).update(rock_params)
        Rock.find(params[:id]).update(assigned:@assigned_array)
        format.html { redirect_to view_projects_path, notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_rocks_reviewedby
    if params[:commit] == "Acknowledge"
      Rock.find(params[:id]).update(reviewed_by: current_user.email + " checked")
      redirect_to view_projects_path
    else
      if params[:reviewed_by].nil?
        redirect_to view_projects_path
      else
        Rock.find(params[:id]).update(reviewed_by: params[:reviewed_by])
        redirect_to view_projects_path
      end
    end
  end

  def delete_rocks
   
    # delete milestone messages,submilestones messages and submilestones
    allmilestone = Rock.find(params[:id]).milestones
    allmilestone.each do |milestone|
      milestone.submilestones.each do |submilestone|
        # delete sub2milestones
        submilestone.sub2milestones.destroy_all
        # delete submilestones ssubmessages
        submilestone.submessages.destroy_all
      end
      # delete submilestones
      milestone.submilestones.destroy_all
      # delete milestones messages
      milestone.messages.destroy_all
    end
    # delete milestones
    Rock.find(params[:id]).milestones.destroy_all
     # delete rock messages
    Rock.find(params[:id]).rockmessages.destroy_all
    # delete rock
    respond_to do |format|
      if Rock.find(params[:id]).destroy
        format.html { redirect_to view_projects_path, notice: "You have successfully deleted you rock" }
      else
        redirect_to view_projects_path
      end
    end
  end

  # def automate_rocks
  #   Rock.first.update(complete:100)
  # end

  # Milestones
  def create_milestones
    @milestone = Rock.find(params[:rock_id]).milestones.new(milestone_params)
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)
    respond_to do |format|
      if @milestone.save
        Rock.find(params[:rock_id]).milestones.last.update(assigned:@assigned_array)
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
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id]}), notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_milestones
    @all_milestones = Rock.find(params[:rock_id]).milestones
    @milestone = current_user.milestones.find(params[:id])
    @milestone.submilestones.each do |submilestone|
      # delete sub2milestones
      submilestone.sub2milestones.destroy_all
      # delete submilestones
      submilestone.destroy
      # delete submilestones submessages
      submilestone.submessages.destroy_all
    end
    # delete milestone messages
    @milestone.messages.destroy_all
    # delete milestone 
    respond_to do |format|
      if @milestone.destroy
        @milestone.handle_complete_change
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
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id],mm_id: params[:milestone_id]}), notice: "You have successfully create a new message" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id],mm_id: params[:milestone_id] })
      end
    end
  end

  def update_message
    respond_to do |format|
      if Milestone.find(params[:milestone_id]).messages.find(params[:id]).update(message_params)
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id],mm_id: params[:milestone_id]}), notice: "You have successfully updated a new message" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id],mm_id: params[:milestone_id]})
      end
    end
  end

  def delete_message
    @message = Milestone.find(params[:milestone_id]).messages.find(params[:id])
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to view_projects_path({rock_id: params[:rock_id],mm_id: params[:milestone_id]}), notice: "You have successfully deleted your message" }
      else
        redirect_to view_projects_path({rock_id: params[:rock_id],mm_id: params[:milestone_id]})
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
    params.permit(:user_id, :task_name, :start, :finish, :assigned, :complete, :remarks, :output, :date_completed)
  end

  def milestone_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :remarks,:user_id, :output, :date_completed)
  end

  def message_params
    params.permit(:message, :first_name, :last_name, :time)
  end

end
