# spec/models/portfolio_spec.rb
require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context 'validations' do
    it 'is valid with valid attributes' do
      portfolio = FactoryBot.build(:portfolio, user: user)
      expect(portfolio).to be_valid
    end

    it 'is invalid with nil stocks' do
      portfolio = FactoryBot.build(:portfolio, stocks: nil, user: user)
      expect(portfolio).not_to be_valid
    end

    it 'is invalid with nil current_shares' do
      portfolio = FactoryBot.build(:portfolio, current_shares: nil, user: user)
      expect(portfolio).not_to be_valid
    end

    it 'is invalid with negative value current_shares' do
      portfolio = FactoryBot.build(:portfolio, current_shares: -1, user: user)
      expect(portfolio).not_to be_valid
    end
  end
end
