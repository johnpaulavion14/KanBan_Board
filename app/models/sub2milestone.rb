class Sub2milestone < ApplicationRecord
  serialize :assigned, Array
  belongs_to :user
  belongs_to :submilestone
  has_many :sub2messages
end
