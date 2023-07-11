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
        if params[:complete] == "100"
          Milestone.find(params[:milestone_id]).submilestones.last.update(date_completed:Date.today)
        end
        if Milestone.find(params[:milestone_id]).submilestones.average(:complete) == 100
          Milestone.find(params[:milestone_id]).update(date_completed:Date.today)
        else
          Milestone.find(params[:milestone_id]).update(date_completed:"")
        end
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
        if params[:complete] == "100"
          @milestone.update(date_completed:Date.today)
        else
          @milestone.update(date_completed:"")
        end
        if Milestone.find(params[:id]).submilestones.average(:complete) == 100
          Milestone.find(params[:id]).update(date_completed:Date.today)
        else
          Milestone.find(params[:id]).update(date_completed:"")
        end
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def delete_submilestones
    @milestone = Submilestone.find(params[:id])
    # delete milestone messages
    # @milestone.messages.destroy_all
    respond_to do |format|
      if @milestone.destroy
        if Milestone.find(params[:rock_id]).submilestones.average(:complete) == 100
          Milestone.find(params[:rock_id]).update(date_completed:Date.today)
        end
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully deleted you milestone" }
      else
        redirect_to view_projects_path
      end
    end
  end

  private

  def submilestone_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :remarks,:user_id, :output, :date_completed)
  end

end
