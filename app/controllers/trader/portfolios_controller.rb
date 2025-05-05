class Trader::PortfoliosController < ApplicationController
  # before_action :set_portfolio
  # before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index
    @portfolios = current_user.portfolios.order(current_shares: :desc)
    @portfolios_active = @portfolios.where("current_shares > 0")
    @symbol = AvaApi.symbols
    @symbol_name = @symbol.to_h.invert

    @portfolios_active_info = @portfolios_active.map do |portfolio|
      price = AvaApi.price_for(portfolio.stocks)
      shares = portfolio.current_shares      
      {
        id: portfolio.id,
        name: @symbol_name[portfolio.stocks],
        symbol: portfolio.stocks,
        price: price,
        shares: shares,
        value: price * shares
      }
    end

    @total_value = @portfolios_active_info.sum { |info| info[:value] }
  end

  def show
    @portfolio = current_user.portfolios.find(params[:id])
    @symbol = AvaApi.symbols
    @symbol_name = @symbol.to_h.invert
    @transactions = current_user.transactions
    @transactions_portfolio = @transactions.where(symbol: @portfolio.stocks)
    @price = AvaApi.price_for(@portfolio.stocks)
    @value = @portfolio.current_shares * @price 
  end

  # def new; end

  # def create
    # @portfolio = current_user.portfolios.new(portfolio_params_stocks)
    # if @symbol.save
    #   redirect_to @symbol, notice: "#{@symbol} was added to your Portfolio."
    # else
    #   flash[:alert] = "Try Again"
    #   render :show, status: :unprocessable_entity
  # end

  # def edit; end

  def update; end
  
  # def destroy
  #   @portfolio.destroy
  #   redirect_to root_path, status: :see_other, notice: "Entry has been deleted."
  # end

  private

  def set_portfolio
    @portfolio = current_user.portfolios.find(params[:id])
  end

  # def record_not_found
  #   redirect_to categories_path, alert: "Record does not exist."
  # end

  # def invalid_foreign_key
  #   redirect_to categories_path, alert: "Unable to delete category. Still referenced from tasks."
  # end
end