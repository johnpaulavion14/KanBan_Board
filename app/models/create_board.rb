class CreateBoard < ApplicationRecord

  belongs_to :user
  has_many :cards
  has_many :addcards, through: :cards

  validates :board_title, presence: true
  validates :board_title,:board_desc, length: { maximum: 20 }
end
