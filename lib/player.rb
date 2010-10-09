class NotEnoughCashError < StandardError
end

class TexasHoldem::Player
  attr_reader :name, :cards, :cash
  
  def initialize(name,cash)
    @name, @cash = name, cash
    @cards = []
  end
  
  def bet(amount)
    raise NotEnoughCashError unless enough_cash_for?(amount)
    @cash -= amount
    amount
  end
  
  def take_winnings(amount)
    @cash += amount
  end
  
  private
  
  def enough_cash_for?(amount)
    @cash > amount
  end
end 
