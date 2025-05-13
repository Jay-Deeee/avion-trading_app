require 'rails_helper'

RSpec.describe "Trader::Transactions", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) do
    { symbol: 'AAPL', shares: 10, action_type: 'buy' }
  end
  let(:invalid_attributes) do
    { symbol: nil, shares: 10, action_type: 'buy' }
  end

  before do
    sign_in user
  end
  
  describe 'GET /index' do
    it 'returns a success response' do
      get trader_transactions_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /create' do
    context 'with valid attributes' do
      it 'creates a new transaction and redirects' do
        expect {
          post trader_transactions_path, params: { transaction: valid_attributes }
        }.to change(Transaction, :count).by(1)
        expect(response).to redirect_to(trader_transactions_path)
        expect(flash[:notice]).to eq("Transaction successful!")
      end
    end

    context 'with invalid attributes' do
      it 'does not create a transaction and re-renders the index' do
        expect {
          post trader_transactions_path, params: { transaction: invalid_attributes }
        }.to_not change(Transaction, :count)
        expect(response).to render_template(:index)
        expect(flash[:alert]).to eq("Unable to fetch the price for the selected stock. Please try again.")
      end
    end
  end

  describe 'GET /get_stock_price' do
    context 'with a valid symbol' do
      it 'returns a success response with the price' do
        allow(AvaApi).to receive(:price_for).with('AAPL').and_return(150.0)
        get get_stock_price_trader_transactions_path, params: { symbol: 'AAPL' }
        expect(response).to be_successful
        expect(JSON.parse(response.body)['price']).to eq(150.0)
      end
    end

    context 'with an invalid symbol' do
      it 'returns a 422 status with "N/A"' do
        allow(AvaApi).to receive(:price_for).with('INVALID').and_return(nil)
        get get_stock_price_trader_transactions_path, params: { symbol: 'INVALID' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['price']).to eq('N/A')
      end
    end
  end
end
