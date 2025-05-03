require "uri"
require "net/http"

class AvaApi
  def self.fetch_records(symbol)
    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=#{symbol}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV["API_KEY"]
    request["x-rapidapi-host"] = "alpha-vantage.p.rapidapi.com"

    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.price_for(symbol)
    data = fetch_records(symbol)
    data.dig("Global Quote", "05. price")&.to_d
  end

  def self.symbols
    [
      ["Apple", "AAPL"],
      ["Microsoft", "MSFT"],
      ["Amazon", "AMZN"],
      ["Tesla", "TSLA"],
      ["Google", "GOOGL"],
      ["Meta", "META"],
      ["Netflix", "NFLX"],
      ["NVIDIA", "NVDA"],
      ["Adobe", "ADBE"],
      ["Intel", "INTC"],
      ["PayPal", "PYPL"]
    ]
  end
end
