class NotEnoughCashError < StandardError
end

class TexasHoldem::Player
  attr_reader :name, :cards, :cash
  
  def initialize(name,cash)
    @name, @cash = name, cash
    @cards = []
  end
  
  def place_bet(minimum)
  end
  
  def bet(amount)
    raise NotEnoughCashError unless enough_cash_for?(amount)
    @cash -= amount
  end
  
  private
  
  def enough_cash_for?(amount)
    @cash > amount
  end
end 
