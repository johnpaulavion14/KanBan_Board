class Milestone < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :rock
  has_many :submilestones
  has_many :messages

  after_save :handle_complete_change, :update_column_data

  def handle_complete_change
  # Compute Rock Percent Column
    if !self.rock.milestones.blank? 
      percent_sum = self.rock.milestones.pluck(:complete).reduce(:+) * 100
      count = self.rock.milestones.count * 100
      total_percent = percent_sum / count
      self.rock.update(complete: total_percent)
    else
      self.rock.update(complete:0)
    end 
  end

  def update_column_data
    # Date completed of Milestone
    date_comp = complete == 100 ? Date.today : ""
    self.update_columns(date_completed: date_comp)
  end

end
