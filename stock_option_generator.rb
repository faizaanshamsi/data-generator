class StockOptionGenerator
  attr_reader :stock, :expiration, :premium
  attr_accessor :chain

  def initialize(stock, expiration, premium, initial_chain)
    @stock = stock
    @expiration = expiration
    @premium = premium
    @chain = initial_chain
  end

  def change_stock_price
    stock.price = stock.price * ((rand(50) + 75.0) / 100.0)
  end

  def formatted_output
    option_output = []
    chain.each do |option|
      option_output << option.formatted_output
    end
    { ticker: stock.ticker,
      current_price: stock.price,
      timestamp: Time.now.to_s,
      chain: option_output
    }
  end
end
