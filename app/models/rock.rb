class Rock < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  has_many :milestones
end
