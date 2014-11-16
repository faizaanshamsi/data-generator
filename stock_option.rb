class StockOption
  attr_reader :stock, :expiration, :strike, :premium, :direction
  def initialize(opts)
    @stock = opts[:stock]
    @expiration = Time.parse(opts[:expiration])
    @strike = opts[:strike]
    @premium = opts[:premium]
    @direction = opts[:direction]
  end

  def interest
    0.0236
  end

  def years_to_expiry
    time = expiration - Time.now
    time.to_f / 31_536_000
  end

  def put?
    direction == 'put'
  end

  def call?
    direction == 'call'
  end

  def midpoint
    if put?
      Option::Calculator.price_put(stock.price, strike, years_to_expiry, interest, stock.sigma, stock.dividend)
    else
      Option::Calculator.price_call(stock.price, strike, years_to_expiry, interest, stock.sigma, stock.dividend)
    end
  end

  def bid
    midpoint - premium
  end

  def ask
    midpoint + premium
  end

  def name
    stock.ticker + expiration.strftime('%d%m%y') + direction_print + sprintf("%08d", strike * 1000)
  end

  def formatted_output
    { Type: direction,
      name: name,
      expiration_date: expiration,
      strike_price: strike,
      current_bid: bid,
      current_ask: ask,
      midpoint: midpoint, 
      close: 0,
      last_price: 0,
      moneyness: 0 
    }
  end

  private

  def direction_print
    direction == 'put' ? 'P' : 'C'
  end
end
