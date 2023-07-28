class Rock < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :project_workspace
  has_many :milestones
  has_many :rockmessages
end
