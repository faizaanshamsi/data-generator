class Stock
  attr_reader :ticker, :price, :sigma, :dividend
  def initialize(opts)
    @ticker = opts[:ticker]
    @price = opts[:price]
    @sigma = opts[:sigma]
    @dividend = opts[:dividend]
  end
end
