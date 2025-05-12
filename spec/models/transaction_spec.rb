require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context 'validations' do
    it 'creates a new transaction with valid attribute values' do
      transaction = FactoryBot.build(:transaction, user: user)
      expect(transaction).to be_valid
    end

    it 'is invalid without a symbol' do
      transaction = FactoryBot.build(:transaction, symbol: nil, user: user)
      expect(transaction).not_to be_valid
    end

    it 'is invalid without shares' do
      transaction = FactoryBot.build(:transaction, shares: nil, user: user)
      expect(transaction).not_to be_valid
    end

    it 'is invalid without a price' do
      transaction = FactoryBot.build(:transaction, price: nil, user: user)
      expect(transaction).not_to be_valid
    end

    it 'is invalid without a total' do
      transaction = FactoryBot.build(:transaction, total: nil, user: user)
      expect(transaction).not_to be_valid
    end

    it 'is invalid without an action type' do
      transaction = FactoryBot.build(:transaction, action_type: nil, user: user)
      expect(transaction).not_to be_valid
    end
  end
end
