class PortfoliosController < ApplicationController
  def index
    response = AvaApi.fetch_records(params[:symbol])
    @symbol = response["Meta Data"]["2. Symbol"]
    @stock_price = response.dig("Time Series (Daily)").values.first.dig("1. open")
  end
end
