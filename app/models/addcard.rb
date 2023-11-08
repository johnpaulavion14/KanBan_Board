class Addcard < ApplicationRecord
  belongs_to :card
  has_many :addcomments
  has_many :todos
  has_many :identifies

  validates :card_name, presence: true
end
