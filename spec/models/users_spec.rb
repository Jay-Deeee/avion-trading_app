require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without a first name' do
      user = FactoryBot.build(:user, first_name: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid without a last name' do
      user = FactoryBot.build(:user, last_name: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid with a negative balance' do
      user = FactoryBot.build(:user, balance: -1)
      expect(user).not_to be_valid
    end
  end

  describe 'full_name value' do
    it 'returns capitalized first + last name' do
      user = FactoryBot.build(:user, first_name: 'john', last_name: 'doe')
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe 'confirmations' do
    it 'is admin approved and email confirmed' do
      user = FactoryBot.build(:user)
      expect(user.active_for_authentication?).to be_truthy
    end

    it 'is admin approved and email unconfirmed' do
      user = FactoryBot.build(:user, confirmed_at: nil)
      expect(user.active_for_authentication?).to be_falsey
    end

    it 'is admin pending approval and email confirmed' do
      user = FactoryBot.build(:user, approved: false)
      expect(user.active_for_authentication?).to be_falsey
    end

    it 'is admin pending approval and email unconfirmed' do
      user = FactoryBot.build(:user, approved: false, confirmed_at: nil)
      expect(user.active_for_authentication?).to be_falsey
    end
  end
end
