require 'rails_helper'

RSpec.describe Trader::PortfoliosController, type: :controller do
  let(:user) { create(:user) }
  let(:portfolio) { create(:portfolio, user: user, current_shares: 10.0, stocks: 'AAPL') }

  before do
    sign_in user
    allow(AvaApi).to receive(:symbols).and_return([['AAPL', 'Apple Inc.']])
    allow(AvaApi).to receive(:price_for).and_return(150.0)
  end

  describe "GET #index" do

    it "computes portfolio info and total value" do
      portfolio
      get :index
      info = assigns(:portfolios_active_info).first
      expect(info[:symbol]).to eq('AAPL')
      expect(info[:value]).to eq(1500.0)
      expect(assigns(:total_value)).to eq(1500.0)
    end
  end

  describe "GET #show" do
    it "assigns the requested portfolio and related data" do
      transaction = create(:transaction, user: user, symbol: 'AAPL')
      get :show, params: { id: portfolio.id }
      expect(assigns(:portfolio)).to eq(portfolio)
      expect(assigns(:transactions)).to include(transaction)
      expect(assigns(:price)).to eq(150.0)
      expect(assigns(:value)).to eq(1500.0)
    end

    it "redirects when record is not found" do
      get :show, params: { id: 999 }
      expect(response).to redirect_to(trader_portfolios_path)
      expect(flash[:alert]).to eq("Record does not exist.")
    end
  end

  describe "POST #add_balance" do
    it "adds balance when amount is valid" do
      post :add_balance, params: { amount: 100.0 }
      expect(user.reload.balance).to eq(5100.0)
      expect(flash[:notice]).to eq("Balance updated.")
    end

    it "does not add balance when amount is invalid" do
      post :add_balance, params: { amount: -10.0 }
      expect(user.reload.balance).to eq(5000.0)
      expect(flash[:alert]).to eq("Enter a valid amount.")
    end
  end

  describe "Access Control" do
    it "redirects admins to admin root" do
      admin = create(:user, email: "admin@sample.com", is_admin: true)
      sign_in admin
      get :index
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("Restricted. Trader Access Only.")
    end
  end
end
