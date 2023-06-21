class Rock < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  has_many :milestones
  has_many :messages , through: :milestones
end
