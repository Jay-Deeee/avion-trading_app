import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["symbol", "price"]

  fetchPrice() {
    const symbol = this.symbolTarget.value;

    if (symbol) {
      fetch(`/trader/transactions/get_stock_price?symbol=${symbol}`)
        .then(response => response.json())
        .then(data => {
          if (data.price) {
            this.priceTarget.innerHTML = `Current Price: $${data.price}`;
          } else {
            this.priceTarget.innerHTML = 'Unable to fetch the price.';
          }
        })
        .catch(() => {
          this.priceTarget.innerHTML = 'Error fetching price.';
        });
    } else {
      this.priceTarget.innerHTML = '';
    }
  }
}
