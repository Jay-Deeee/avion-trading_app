class Trader::PortfoliosController < ApplicationController
  # before_action :set_portfolio
  # before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index
    @portfolios = current_user.portfolios.order(current_shares: :desc)
    @portfolios_active = @portfolios.where("current_shares > 0")
    @symbols = AvaApi.symbols
    @symbol_name = @symbols.to_h.invert
    @balance = current_user.balance

    @portfolios_active_info = @portfolios_active.map do |portfolio|
      price_avaapi = AvaApi.price_for(portfolio.stocks)
      shares = portfolio.current_shares
      if price_avaapi == nil
        price = "N/A"
        value = "N/A"
      else
        price = price_avaapi
        value = price_avaapi * shares
      end
      {
        id: portfolio.id,
        name: @symbol_name[portfolio.stocks],
        symbol: portfolio.stocks,
        price: price,
        shares: shares,
        value: value
      }
    end

    @total_value = @portfolios_active_info.sum { |info| info[:value].is_a?(Numeric) ? info[:value] : 0 }
    @slice_size = (@symbols.size).ceil
  end

  def show
    @portfolio = current_user.portfolios.find(params[:id])
    @symbols = AvaApi.symbols
    @symbol_name = @symbols.to_h.invert
    @transactions = current_user.transactions
    @transactions_portfolio = @transactions.where(symbol: @portfolio.stocks)
    @price = AvaApi.price_for(@portfolio.stocks)
    @value = @portfolio.current_shares * @price 
  end

  def add_balance
    amount = params[:amount].to_f
    if amount > 0
      current_user.increment!(:balance, amount)
      redirect_back fallback_location: root_path, notice: "Balance updated."
    else
      redirect_back fallback_location: root_path, alert: "Enter a valid amount."
    end
  end

  private

  # def record_not_found
  #   redirect_to categories_path, alert: "Record does not exist."
  # end

  # def invalid_foreign_key
  #   redirect_to categories_path, alert: "Unable to delete category. Still referenced from tasks."
  # end
end