class Card < ApplicationRecord
  belongs_to :create_board
  has_many :addcards
  has_many :addcomments, through: :addcards

  validates :card_title, presence: true
end
