class TexasHoldem::Game
  attr_reader :players, :entrance_fee
  
  def initialize(players,entrance_fee)
    @players, @entrance_fee = players, entrance_fee
  end
  
  def pot
    @players.size * @entrance_fee
  end
  
  def winner
  end
end
