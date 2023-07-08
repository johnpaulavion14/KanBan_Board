class ProjectWorkspace < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  has_many :rocks
end
