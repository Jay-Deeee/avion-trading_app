require 'rails_helper'

RSpec.describe "Admin::Transactions", type: :request do
  let(:admin) { FactoryBot.create(:user, is_admin: true) }
  let(:trader) { FactoryBot.create(:user, email: "trader@gmail.com") }
  let(:transaction) { FactoryBot.create(:transaction, user: trader) }

  before do
    allow(AvaApi).to receive(:symbols).and_return({ "AAPL" => "Apple" })
    sign_in admin
  end

  describe "GET /admin/transactions" do
    it "returns a successful response" do
      get admin_transactions_path
      expect(response).to be_successful
    end
  end

  describe "GET /admin/transactions/:id" do
    it "returns a successful response for a valid transaction" do
      get admin_transaction_path(transaction)
      expect(response).to have_http_status(:ok)
    end

    it "redirects to index if transaction not found" do
      get admin_transaction_path("nonexistent-id")
      expect(response).to redirect_to(admin_transactions_path)
      expect(flash[:alert]).to eq("Record does not exist.")
    end
  end
end
