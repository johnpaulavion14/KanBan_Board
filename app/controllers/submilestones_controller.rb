class SubmilestonesController < ApplicationController
  before_action :authenticate_user!
 
  # Sub Milestones
  def create_submilestones
    @milestone = Milestone.find(params[:milestone_id]).submilestones.new(submilestone_params)
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)
    respond_to do |format|
      if @milestone.save
        Milestone.find(params[:milestone_id]).submilestones.last.update(assigned:@assigned_array)
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully create a new milestone" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_submilestones
    @milestone = Milestone.find(params[:milestone_id]).submilestones.find(params[:id])
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(@milestone.user.email)
    @assigned_array.insert(0, @milestone.user.email)
    respond_to do |format|
      if @milestone.update(submilestone_params)
        @milestone.update(assigned:@assigned_array)
        Milestone.find(params[:milestone_id]).rock.update(date_completed:"")
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
  
    
  end

  def delete_submilestones
    @submilestone = Submilestone.find(params[:id])
    @submilestone.sub2milestones.destroy_all
    @submilestone.submessages.destroy_all
    respond_to do |format|
      if @submilestone.destroy
        @submilestone.handle_complete_change
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully deleted you milestone" }
      else
        redirect_to view_projects_path
      end
    end
  end

  # Sub Milestone Messages
  def create_submessage
    respond_to do |format|
      if Submilestone.find(params[:submilestone_id]).submessages.create(submessage_params)
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id],sm_id: params[:submilestone_id]}), notice: "You have successfully create a new message" }
      else
        redirect_to view_projects_path()
      end
    end
  end

  def update_submessage
    respond_to do |format|
      if Submilestone.find(params[:submilestone_id]).submessages.find(params[:id]).update(submessage_params)
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id],sm_id: params[:submilestone_id]}), notice: "You have successfully updated a new message" }
      else
        redirect_to view_projects_path()
      end
    end
  end

  def delete_submessage
    @message = Submilestone.find(params[:submilestone_id]).submessages.find(params[:id])
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id],sm_id: params[:submilestone_id]}), notice: "You have successfully deleted your message" }
      else
        redirect_to view_projects_path()
      end
    end
  end

  private

  def submilestone_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :remarks,:user_id, :output, :date_completed)
  end

  def submessage_params
    params.permit(:message, :first_name, :last_name, :time)
  end

end
