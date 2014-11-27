require 'time'
require 'options_library'
require 'json'
require 'redis'
require_relative 'stock'
require_relative 'stock_option'
require_relative 'stock_option_generator'
require 'uri'
require 'net/https'
require 'pry'

def build_chain(raw_chain, stock, expiration, premium)
  chain = []
  raw_chain.each do |option|
    option_strike = option['strike']
    direction = option['description'] =~ /Call/ ? 'call' : 'put'
    chain << StockOption.new({stock: stock, expiration: expiration, strike: option_strike, premium: premium, direction: direction})
  end
  chain
end

uri = URI.parse("https://sandbox.tradier.com/v1/markets/quotes?symbols=googl")
http = Net::HTTP.new(uri.host, uri.port)
http.read_timeout = 30
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
request = Net::HTTP::Get.new(uri.request_uri)
request["Accept"] = "application/json"
request["Authorization"] = "Bearer pA37f9VPNumjiTWNO0tRxEGcu5S1"
response = http.request(request)
result = JSON.parse(response.body)

def stock(result)
  {
    ticker: 'GOOG',
    price: result['quotes']['quote']['last'],
    sigma: 0.1,
    dividend: 0
  }
end

expiration = 'Jan 17 2015 15:59:59 EST'
s = Stock.new(stock(result))
premium = 0.05

uri = URI.parse("https://sandbox.tradier.com/v1/markets/options/chains?symbol=goog&expiration=2015-01-17")
http = Net::HTTP.new(uri.host, uri.port)
http.read_timeout = 30
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
request = Net::HTTP::Get.new(uri.request_uri)
request["Accept"] = "application/json"
request["Authorization"] = "Bearer pA37f9VPNumjiTWNO0tRxEGcu5S1"
response = http.request(request)
result = JSON.parse(response.body)

raw_chain = result['options']['option']

chain = build_chain(raw_chain, s, expiration, premium)

# Fetch options chain
# Create options based on chain
redis = Redis.new(url: ENV['REDIS_URL'])
# Loop do
  # Update stock price
  # Update each option by repricing
  # push chain to redis
sg = StockOptionGenerator.new(s, expiration, 0.1, chain)
while true do
  sleep 1
  sg.change_stock_price
  puts sg.formatted_output.to_json
  # redis_output = sg.formatted_output.to_json
  # push to redis
  # redis.lpush(stock[:ticker], redis_output)
end
