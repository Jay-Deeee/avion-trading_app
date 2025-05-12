class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :portfolios
  has_many :transactions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true

  def active_for_authentication?
    super && approved?
  end
  
  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
