class Transaction < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true
  validates :shares, presence: true
  validates :price, presence: true
  validates :total, presence: true
  validates :action_type, presence: true
end
