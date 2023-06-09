class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  
  validates :first_name,:last_name, uniqueness: true
  
  has_many :create_boards
  has_many :cards
  has_many :cards, through: :create_boards
  has_many :addcards , through: :cards
  has_many :profilepics
  has_many :rocks
  has_many :milestones
end
