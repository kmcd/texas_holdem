class BettingRound
  def initialize(players)
    @betting_circle = players.enum_for
  end
  
  def next_player
    @betting_circle.next
    
    rescue StopIteration
      @betting_circle.rewind
      @betting_circle.next
  end
end
