class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks


  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end


  def self.new_from_lookup(ticker_symbol)
    begin
      logger.debug ticker_symbol
      client = IEX::Api::Client.new(publishable_token: 'pk_98bf6381d1d4462fb0911c5206085181')
      looked_up_stock = client.quote(ticker_symbol)
      logger.debug looked_up_stock
      new(name: looked_up_stock.company_name,
          ticker: looked_up_stock.symbol, last_price: looked_up_stock.latest_price)
    rescue Exception => e
      logger.error("uncaught #{e} exception while handling connection: #{e.message}")
      return nil
    end
  end
end
