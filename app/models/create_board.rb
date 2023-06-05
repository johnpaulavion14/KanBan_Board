class CreateBoard < ApplicationRecord

  belongs_to :user
  has_many :cards
  has_many :addcards, through: :cards

  validates :board_title, presence: true
end
