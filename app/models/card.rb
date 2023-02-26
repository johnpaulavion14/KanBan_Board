class Card < ApplicationRecord
  belongs_to :user
  has_many :addcards

  validates :card_title, presence: true
end
