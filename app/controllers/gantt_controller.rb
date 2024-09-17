class GanttController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @tasks_content = Task.all.where(progress:0.1e1).pluck(:text)
    @off_track_array = Rock.where("finish < ?", Date.today).pluck(:task_name) + Milestone.where("finish < ?", Date.today).pluck(:task_name) + Submilestone.where("finish < ?", Date.today).pluck(:task_name) + Sub2milestone.where("finish < ?", Date.today).pluck(:task_name)
  end

  def data 
    tasks = Task.all
    links = Link.all
 
    render :json=>{
      :data => tasks.order(:sortorder).map{|task|{ 
        :id => task.id,
        :text => task.text,
        :start_date => task.start_date.to_formatted_s(:db),
        :duration => task.duration,
        :progress => task.progress,
        :parent => task.parent,
        :open => true
      }},
      :links => links.map{|link|{
        :id => link.id,
        :source => link.source,
        :target => link.target,
        :type => link.link_type
      }}
    }
  end

  
  def update_gantt
    Task.all.destroy_all
    Rock.all.order(finish: :asc, created_at: :asc).each do |rock|
      Task.create(text:rock.task_name, start_date:rock.start, duration:rock.finish-rock.start+1,parent:0,sortorder:0, progress:rock.complete/100.to_f)
      r_last_id = Task.last.id
      rock.milestones.order(start: :asc, created_at: :asc).each do |milestone|
        Task.create(text:milestone.task_name, start_date:milestone.start, duration:milestone.finish-milestone.start+1,parent:r_last_id,sortorder:0, progress:milestone.complete/100.to_f)
        m_last_id = Task.last.id
        milestone.submilestones.order(start: :asc, created_at: :asc).each do |submilestone|
          Task.create(text:submilestone.task_name, start_date:submilestone.start, duration:submilestone.finish-submilestone.start+1,parent:m_last_id,sortorder:0, progress:submilestone.complete/100.to_f)
          subm_last_id = Task.last.id
          submilestone.sub2milestones.order(start: :asc, created_at: :asc).each do |sub2milestone|
            Task.create(text:sub2milestone.task_name, start_date:sub2milestone.start, duration:sub2milestone.finish-sub2milestone.start+1,parent:subm_last_id,sortorder:0, progress:sub2milestone.complete/100.to_f)
          end
        end
      end
    end
  end

  respond_to do |format|
    format.html { redirect_to gantt_path, notice: "" }
    format.json { head :no_content }
  end

end
