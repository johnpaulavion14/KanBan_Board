class ProjectWorkspacesController < ApplicationController
  before_action :authenticate_user!
 
  def create_workspace
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)

    respond_to do |format|
      if current_user.project_workspaces.create(workspace_params)
        current_user.project_workspaces.last.update(assigned:@assigned_array)
        format.html { redirect_to projects_dashboard_path, notice: "You have successfully create a new workspace" }
      else
        redirect_to projects_dashboard_path
      end
    end
  end

  def update_workspace  
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)
    respond_to do |format|
      if current_user.project_workspaces.find(params[:id]).update(workspace_params)
        current_user.project_workspaces.find(params[:id]).update(assigned:@assigned_array)
        format.html { redirect_to projects_dashboard_path, notice: "You have successfully updated your workspace" }
      else
        redirect_to projects_dashboard_path
      end
    end
  end

  def delete_workspace
     # delete milestone messages and all submilestones
     ProjectWorkspace.find(params[:id]).rocks.each do |rock|
      rock.milestones.each do |milestone|
        milestone.messages.destroy_all
        milestone.submilestones.destroy_all
      end
      # delete rock messages
      rock.rockmessages.destroy_all
       # delete rocks and milestones
      rock.milestones.destroy_all
      rock.destroy
      end
    respond_to do |format|
      if current_user.project_workspaces.find(params[:id]).destroy
        format.html { redirect_to projects_dashboard_path, notice: "You have successfully deleted your workspace" }
      else
        redirect_to projects_dashboard_path
      end
    end
  end

  private

  def workspace_params
    params.permit(:folder_name, :assigned)
  end

end
