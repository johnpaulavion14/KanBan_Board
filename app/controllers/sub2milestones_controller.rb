class Sub2milestonesController < ApplicationController
  before_action :authenticate_user!
 
  # Sub Milestones
  def create_sub2milestones
    @sub2milestone = Submilestone.find(params[:submilestone_id]).sub2milestones.new(sub2milestone_params)
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(current_user.email)
    @assigned_array.insert(0, current_user.email)
    respond_to do |format|
      if @sub2milestone.save
        Submilestone.find(params[:submilestone_id]).sub2milestones.last.update(assigned:@assigned_array)
        if params[:complete] == "100"
          Submilestone.find(params[:submilestone_id]).sub2milestones.last.update(date_completed:Date.today)
        end
        if Submilestone.find(params[:submilestone_id]).sub2milestones.average(:complete) == 100
          Submilestone.find(params[:submilestone_id]).update(date_completed:Date.today)
        else
          Submilestone.find(params[:submilestone_id]).update(date_completed:"")
        end
        # # Compute Milestone Percent Column
        # m_percent_sum = Milestone.find(params[:milestone_id]).submilestones.pluck(:complete).reduce(:+) * 100
        # subm_count = Milestone.find(params[:milestone_id]).submilestones.count * 100
        # total_m_percent = m_percent_sum / subm_count
        # Milestone.find(params[:milestone_id]).update(complete: total_m_percent)
        # # Compute Rock Percent Column
        # r_percent_sum = Milestone.find(params[:milestone_id]).rock.milestones.pluck(:complete).reduce(:+) * 100
        # m_count = Milestone.find(params[:milestone_id]).rock.milestones.count * 100
        # total_r_percent = r_percent_sum / m_count
        # Milestone.find(params[:milestone_id]).rock.update(complete: total_r_percent)
        # # Update Rock date_compeleted
        # if Milestone.find(params[:milestone_id]).rock.complete == 100
        #   Milestone.find(params[:milestone_id]).rock.update(date_completed:Date.today)
        # else
        #   Milestone.find(params[:milestone_id]).rock.update(date_completed:"")
        # end
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully create a new milestone" }
      else
        redirect_to view_projects_path
      end
    end
    
  end

  def update_sub2milestones
    @sub2milestone = Submilestone.find(params[:submilestone_id]).sub2milestones.find(params[:id])
    @assigned_array = params[:assigned].reject(&:empty?)
    @assigned_array.delete(@sub2milestone.user.email)
    @assigned_array.insert(0, @sub2milestone.user.email)
    respond_to do |format|
      if @sub2milestone.update(sub2milestone_params)
        @sub2milestone.update(assigned:@assigned_array)
        if params[:complete] == "100"
          @sub2milestone.update(date_completed:Date.today)
        else
          @sub2milestone.update(date_completed:"")
        end
        # if Milestone.find(params[:milestone_id]).submilestones.average(:complete) == 100
        #   Milestone.find(params[:milestone_id]).update(date_completed:Date.today)
        # else
        #   Milestone.find(params[:milestone_id]).update(date_completed:"")
        # end
        # Compute Milestone Percent Column
        # m_percent_sum = Milestone.find(params[:milestone_id]).submilestones.pluck(:complete).reduce(:+) * 100
        # subm_count = Milestone.find(params[:milestone_id]).submilestones.count * 100
        # total_m_percent = m_percent_sum / subm_count
        # Milestone.find(params[:milestone_id]).update(complete: total_m_percent)
        # # Compute Rock Percent Column
        # r_percent_sum = Milestone.find(params[:milestone_id]).rock.milestones.pluck(:complete).reduce(:+) * 100
        # m_count = Milestone.find(params[:milestone_id]).rock.milestones.count * 100
        # total_r_percent = r_percent_sum / m_count
        # Milestone.find(params[:milestone_id]).rock.update(complete: total_r_percent)
        # # Update Rock date_compeleted
        # if Milestone.find(params[:milestone_id]).rock.complete == 100
        #   Milestone.find(params[:milestone_id]).rock.update(date_completed:Date.today)
        # else
        #   Milestone.find(params[:milestone_id]).rock.update(date_completed:"")
        # end
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully updated your project" }
      else
        redirect_to view_projects_path
      end
    end
  
    
  end

  def delete_sub2milestones
    # @all_submilestones = Milestone.find(params[:milestone_id]).submilestones
    @sub2milestone = Sub2milestone.find(params[:id])
    # @sub2milestone.submessages.destroy_all
    respond_to do |format|
      if @sub2milestone.destroy
        if Submilestone.find(params[:submilestone_id]).sub2milestones.average(:complete) == 100
          Submilestone.find(params[:submilestone_id]).update(date_completed:Date.today)
        else
          Submilestone.find(params[:submilestone_id]).update(date_completed:"")
        end
        # # Compute Milestone Percent Column
        # m_percent_sum = @all_submilestones.blank? ? 0 : @all_submilestones.pluck(:complete).reduce(:+) * 100
        # subm_count = @all_submilestones.blank? ? 0 : @all_submilestones.count * 100
        # total_m_percent = @all_submilestones.blank? ? 0 : m_percent_sum / subm_count
        # Milestone.find(params[:milestone_id]).update(complete: total_m_percent)
        # # Compute Rock Percent Column
        # r_percent_sum = Milestone.find(params[:milestone_id]).rock.milestones.pluck(:complete).reduce(:+) * 100
        # m_count = Milestone.find(params[:milestone_id]).rock.milestones.count * 100
        # total_r_percent = r_percent_sum / m_count
        # Milestone.find(params[:milestone_id]).rock.update(complete: total_r_percent)
        # Update Rock date_compeleted
        # if Milestone.find(params[:milestone_id]).rock.complete == 100
        #   Milestone.find(params[:milestone_id]).rock.update(date_completed:Date.today)
        # else
        #   Milestone.find(params[:milestone_id]).rock.update(date_completed:"")
        # end
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id]}), notice: "You have successfully deleted you milestone" }
      else
        redirect_to view_projects_path
      end
    end
  end

  # Sub2milestone Messages
  def create_sub2message
    respond_to do |format|
      if Submilestone.find(params[:submilestone_id]).submessages.create(submessage_params)
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id],sm_id: params[:submilestone_id]}), notice: "You have successfully create a new message" }
      else
        redirect_to view_projects_path()
      end
    end
  end

  def update_sub2message
    respond_to do |format|
      if Submilestone.find(params[:submilestone_id]).submessages.find(params[:id]).update(submessage_params)
        format.html { redirect_to view_projects_path({rock_id:params[:rock_id],milestone_id: params[:milestone_id],sm_id: params[:submilestone_id]}), notice: "You have successfully updated a new message" }
      else
        redirect_to view_projects_path()
      end
    end
  end

  def delete_sub2message
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

  def sub2milestone_params
    params.permit(:task_name, :start, :finish, :assigned, :complete, :remarks,:user_id, :output, :date_completed)
  end

  def sub2message_params
    params.permit(:message, :first_name, :last_name, :time)
  end

end
