require "uri"
require "net/http"

class SymbolSearch
  def self.search(keyword)
    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=SYMBOL_SEARCH&keywords=#{keyword}")
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["API_KEY"]
    request["X-RapidAPI-Host"] = "alpha-vantage.p.rapidapi.com"

    response = http.request(request)
    JSON.parse(response.body)
  end
end
