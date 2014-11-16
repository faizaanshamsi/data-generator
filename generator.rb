require 'time'
require 'options_library'
require 'json'
require 'redis'
require_relative 'stock'
require_relative 'stock_option'
require_relative 'stock_option_generator'

def stock
  {
    ticker: 'GOOGL',
    price: (530 + rand(50)),
    sigma: 0.1,
    dividend: 0
  }
end

expiration = 'Dec 14 2014 15:59:59 EST'
redis = Redis.new(url: ENV['REDIS_URL'])

while true do
  sleep 1
  s = Stock.new(stock)
  sg = StockOptionGenerator.new(s, expiration, 0.1)
  
  # push to redisi
  redis.lpush(stock[:ticker], sg.formatted_output.to_json)
end
