class Milestone < ApplicationRecord
  serialize :assigned, Array
  belongs_to :rock
end
