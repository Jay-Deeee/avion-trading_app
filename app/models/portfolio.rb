class Portfolio < ApplicationRecord
  belongs_to :user

  validates :current_shares, numericality: { greater_than_or_equal_to: 0 }
end
