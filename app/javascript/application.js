// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", function() {
  const stockSymbolSelect = document.getElementById("transaction_symbol");
  const stockPriceDiv = document.getElementById("stock_price");

  stockSymbolSelect.addEventListener("change", function() {
    const symbol = stockSymbolSelect.value;

    if (symbol) {
      fetch(`/trader/transactions/get_stock_price?symbol=${symbol}`, {
        method: 'GET',
      })
      .then(response => response.json())
      .then(data => {
        if (data.price) {
          stockPriceDiv.innerHTML = `Current Price: ${data.price}`;
        } else {
          stockPriceDiv.innerHTML = 'Unable to fetch the price.';
        }
      })
      .catch(() => {
        stockPriceDiv.innerHTML = 'Error fetching price.';
      });
    } else {
      stockPriceDiv.innerHTML = '';
    }
  });
});
