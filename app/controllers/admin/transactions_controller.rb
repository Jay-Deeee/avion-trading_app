class Admin::TransactionsController < ApplicationController
  # before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  
  # def index; end
  # def show; end
  # def new; end
  # def create; end
  # def edit; end
  # def update; end

  def destroy
    @transaction.destroy

    redirect_to @portfolio, status: :see_other, notice: "Transaction has been deleted."
  end
  
  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # def record_not_found
  #   redirect_to categories_path, alert: "Record does not exist."
  # end

  # def invalid_foreign_key
  #   redirect_to categories_path, alert: "Unable to delete category. Still referenced from tasks."
  # end
end
