class Addcard < ApplicationRecord
  belongs_to :card
  has_many :addcomments

  validates :card_name, presence: true
end
