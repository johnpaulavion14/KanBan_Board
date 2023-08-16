class Submilestone < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :milestone
  has_many :submessages
  has_many :sub2milestones


  after_save :handle_complete_change, :update_column_data

  def handle_complete_change
  # Compute Milestone Percent Column
    if !self.milestone.submilestones.blank? 
      percent_sum = self.milestone.submilestones.pluck(:complete).reduce(:+) * 100
      count = self.milestone.submilestones.count * 100
      total_percent = percent_sum / count
      self.milestone.update(complete: total_percent)
    else
      self.milestone.update(complete:0)
    end 
  end

  def update_column_data
    # Date completed of submilestone
    date_comp = complete == 100 ? Date.today : ""
    self.update_columns(date_completed: date_comp)
  end
  

end
