class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :portfolios
  has_many :transactions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true
end
