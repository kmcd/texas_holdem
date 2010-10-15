class NotEnoughCashError < StandardError
end

require 'observer'

class TexasHoldem::Player
  attr_reader :name, :cards, :cash
  include Observable
  
  def initialize(name,cash)
    @name, @cash = name, cash
    @cards = []
  end
  
  def bet(amount)
    # TODO: add remaining cash instead of raising an error
    raise NotEnoughCashError unless enough_cash_for?(amount)
    @cash -= amount
    changed true
    notify_observers :bet => { :player => self, :amount => amount }
    amount
  end
  
  def check
    bet 0
  end
  
  def fold
    changed true
    notify_observers :fold => true
  end
  
  def take_winnings(amount)
    @cash += amount
  end
  
  private
  
  def enough_cash_for?(amount)
    @cash > amount
  end
end 
