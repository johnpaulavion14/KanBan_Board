class Card < ApplicationRecord
  belongs_to :create_board
  has_many :addcards

  validates :card_title, presence: true
end
