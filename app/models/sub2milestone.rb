class Sub2milestone < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :submilestone
  has_many :sub2messages

  after_save :handle_complete_change, :update_column_data

  def handle_complete_change
  # Compute Submilestone Percent Column
    if !self.submilestone.sub2milestones.blank? 
      # Date completed and Complete of submilestone
      percent_sum = self.submilestone.sub2milestones.pluck(:complete).reduce(:+) * 100
      count = self.submilestone.sub2milestones.count * 100
      total_percent = percent_sum / count
      self.submilestone.update(complete:total_percent)
    else
      self.submilestone.update(complete:0)
    end
  end

  def update_column_data
    # Date completed of sub2milestone
    date_comp = complete == 100 ? Date.today : ""
    self.update_columns(date_completed: date_comp)
  end

end
