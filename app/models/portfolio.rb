class Portfolio < ApplicationRecord
  belongs_to :user

  validates :stocks, presence: true
  validates :current_shares, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
