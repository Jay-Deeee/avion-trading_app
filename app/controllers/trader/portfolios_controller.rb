class Trader::PortfoliosController < ApplicationController
  before_action :require_trader!
  before_action :set_symbols_and_names, only: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @portfolios = current_user.portfolios.order(current_shares: :desc)
    @portfolios_active = @portfolios.where("current_shares > 0")
    @balance = current_user.balance

    @portfolios_active_info = recreate_portfolio_info(@portfolios_active)
    @total_value = compute_total_value(@portfolios_active_info)
  end

  def show
    @portfolio = current_user.portfolios.find(params[:id])
    @transactions = current_user.transactions.where(symbol: @portfolio.stocks)
    @price = AvaApi.price_for(@portfolio.stocks)
    @value = @portfolio.current_shares * @price 
  end

  def add_balance
    amount = params[:amount].to_f
    if amount.positive?
      current_user.increment!(:balance, amount)
      redirect_back fallback_location: root_path, notice: "Balance updated."
    else
      redirect_back fallback_location: root_path, alert: "Enter a valid amount."
    end
  end

  private

  def require_trader!
    if current_user.is_admin? && request.path != admin_root_path
      redirect_to admin_root_path, alert: "Restricted. Trader Access Only."
    end
  end

  def set_symbols_and_names
    @symbols = AvaApi.symbols
    @symbol_name = @symbols.to_h.invert
  end

  def recreate_portfolio_info(portfolios)
    portfolios.map do |portfolio|
      shares = portfolio.current_shares
      price = AvaApi.price_for(portfolio.stocks)
      value = price ? price * shares : "N/A"

      {
        id: portfolio.id,
        name: @symbol_name[portfolio.stocks],
        symbol: portfolio.stocks,
        price: price || "N/A",
        shares: shares,
        value: value
      }
    end
  end

  def compute_total_value(portfolios_info)
    portfolios_info.sum { |info| info[:value].is_a?(Numeric) ? info[:value] : 0 }
  end

  def record_not_found
    redirect_to trader_portfolios_path, alert: "Record does not exist."
  end
end