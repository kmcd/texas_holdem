class TexasHoldem::Player
  attr_reader :name, :cards
  
  def initialize(name=nil)
    @name, @cards = name, []
  end
end 
