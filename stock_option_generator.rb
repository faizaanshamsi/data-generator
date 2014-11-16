class StockOptionGenerator
  attr_reader :stock, :expiration, :premium

  def initialize(stock, expiration, premium)
    @stock = stock
    @expiration = expiration
    @premium = premium
  end

  def put_strike_prices
    prices = []
    (5..15).each do |i|
      pct = i / 100.0
      prices << (stock.price * (1 - pct))
    end
    prices
  end

  def call_strike_prices
    prices = []
    (5..15).each do |i|
      pct = i / 100.0
      prices << (stock.price * (1 + pct))
    end
    prices
  end
  
  def options
    @options ||= generate
  end

  def generate
    options = []
    put_strike_prices.each do |psp|
      options << StockOption.new({stock: stock, strike: psp, expiration: expiration, premium: premium, direction: 'put'})
    end

    call_strike_prices.each do |csp|
      options << StockOption.new({stock: stock, strike: csp, expiration: expiration, premium: premium, direction: 'call'})
    end
    options
  end

  def formatted_output
    option_output = []
    options.each do |option|
      option_output << option.formatted_output
    end
    { ticker: stock.ticker,
      current_price: stock.price,
      timestamp: Time.now.to_s,
      chain: option_output
    }
  end
end
