class Rock < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :project_workspace
  has_many :milestones
  has_many :rockmessages

  after_save :update_column_data

  private

  def update_column_data
    reviewed_by_value = complete != 100 ? "" : reviewed_by
    self.update_columns(reviewed_by: reviewed_by_value)
  end
end
