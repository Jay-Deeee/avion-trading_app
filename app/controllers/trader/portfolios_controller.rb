class Trader::PortfoliosController < ApplicationController
    # before_action :set_portfolio
    # before_action :set_transaction, only: [:show, :edit, :update, :destroy]
    # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  
    def index
      response = AvaApi.fetch_records(params[:symbol])
      @symbol = response["Meta Data"]["2. Symbol"]
      @stock_price = response.dig("Time Series (Daily)").values.first.dig("1. open")
    end
  
    # def show; end
    # def new; end
    # def create; end
    # def edit; end
    # def update; end
    
    def destroy
      @portfolio.destroy
      redirect_to root_path, status: :see_other, notice: "Entry has been deleted."
    end
  
    private
  
    def set_portfolio
      @portfolio = current_user.portfolios.find(params[:id])
    end
  
    def portfolio_params
      params.require(:portfolio).permit(:name)
    end
  
    # def record_not_found
    #   redirect_to categories_path, alert: "Record does not exist."
    # end
  
    # def invalid_foreign_key
    #   redirect_to categories_path, alert: "Unable to delete category. Still referenced from tasks."
    # end
  end