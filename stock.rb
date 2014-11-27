class Stock
  attr_reader :ticker, :sigma, :dividend
  attr_accessor :price
  def initialize(opts)
    @ticker = opts[:ticker]
    @price = opts[:price]
    @sigma = opts[:sigma]
    @dividend = opts[:dividend]
  end
end
