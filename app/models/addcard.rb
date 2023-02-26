class Addcard < ApplicationRecord
  belongs_to :card

  validates :card_name, presence: true
end
