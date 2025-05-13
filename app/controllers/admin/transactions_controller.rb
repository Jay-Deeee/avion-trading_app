class Admin::TransactionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @users = User.all
    @transactions = Transaction.includes(:user).order(created_at: :desc)
    load_api_symbols
  end

  def show
    @transaction = Transaction.find(params[:id])
    load_api_symbols
  end

  def destroy
    @transaction.destroy

    redirect_to admin_transactions_path, status: :see_other, notice: "Transaction has been deleted."
  end
  
  private

  def load_api_symbols
    @symbols = AvaApi.symbols
    @symbol_name = AvaApi.symbols.to_h.invert
  end

  def record_not_found
    redirect_to admin_transactions_path, alert: "Record does not exist."
  end
end
