class Submilestone < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :milestone
  has_many :submessages
end
