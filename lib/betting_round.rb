class BettingRound
  attr_reader :pot
  
  def initialize(players,hand)
    @players, @hand = players, hand
    @betting_circle = players.enum_for
    @pot = 0
    @bets = []
  end
  
  def next_player
    @betting_circle.next
    
    rescue StopIteration
      @betting_circle.rewind
      @betting_circle.next
  end
  
  def check(player)
    @bets << :check
  end
  
  def raise(player, amount)
    @bets << :raise
    @pot += amount
  end
  
  def fold(player)
    @players.delete player
    @hand.fold player # TODO: use an Observer instead?
  end
  
  def finished?
    return true if @players.size == 1
    @bets[-@players.size..-1].all? {|bet| bet == :check }
  end
end
