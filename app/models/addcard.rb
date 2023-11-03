class Addcard < ApplicationRecord
  belongs_to :card
  has_many :addcomments
  has_many :todos

  validates :card_name, presence: true
end
