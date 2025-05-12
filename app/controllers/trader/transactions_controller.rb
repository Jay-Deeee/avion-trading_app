class Trader::TransactionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    @transaction = current_user.transactions.new
    load_index_data
  end

  # def show; end

  def new
    @transaction = current_user.transactions.new
    load_index_data
  end

  def create
    price = AvaApi.price_for(transaction_params[:symbol])
    shares = transaction_params[:shares].to_d

    if price.nil?
      flash[:alert] = "Unable to fetch the price for the selected stock. Please try again."
      load_index_data
      render :index and return
    end

    total = price * shares
  
    @transaction = current_user.transactions.build(transaction_params)
    @transaction.price = price
    @transaction.total = total
  
    if @transaction.action_type == "buy"
      if current_user.balance < total
        flash[:alert] = "Insufficient funds to complete the purchase."
        load_index_data
        render :index, status: :unprocessable_entity and return
      else
        current_user.balance -= total
      end
    elsif @transaction.action_type == "sell"
      portfolio = current_user.portfolios.find_by(stocks: @transaction.symbol)
      if portfolio.nil? || portfolio.current_shares < shares
        flash[:alert] = "You don't have enough shares to sell."
        load_index_data
        render :index, status: :unprocessable_entity and return
      else
        current_user.balance += total
      end
    end
  
    ActiveRecord::Base.transaction do
      @transaction.save!
      current_user.save!
      create_update_portfolio(@transaction.symbol, shares)
    end
  
    redirect_to trader_transactions_path, notice: "Transaction successful!"

  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "Transaction Failed."
    load_index_data
    render :index, status: :unprocessable_entity
  end

  def get_stock_price
    symbol = params[:symbol]
    price = AvaApi.price_for(symbol)

    if price
      render json: { price: price }
    else
      render json: { price: 'N/A' }, status: :unprocessable_entity
    end
  end

  # def edit; end
  # def update; end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    redirect_to trader_transactions_path, status: :see_other, notice: "Transaction has been deleted."
  end
  
  private

  def transaction_params
    params.require(:transaction).permit(:symbol, :shares, :action_type)
  end

  def create_update_portfolio(symbol, shares)
    portfolio = current_user.portfolios.find_or_initialize_by(stocks: symbol)
    portfolio.current_shares ||= 0

    if @transaction.action_type == "buy"
      portfolio.current_shares += shares
    elsif @transaction.action_type == "sell"
      if portfolio.current_shares >= shares
        portfolio.current_shares -= shares
      else
        flash[:alert] = "Insuficient shares to sell."
      end
    end
    portfolio.save
  end

  def load_index_data
    @transactions = current_user.transactions.order(created_at: :desc)
    @symbols = AvaApi.symbols
    @symbol_name = AvaApi.symbols.to_h.invert
  end

  def record_not_found
    redirect_to trader_transactions_path, alert: "Record does not exist."
  end
end
