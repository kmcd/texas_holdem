class TexasHoldem::Deck
  FACES, SUITS = "AKQJT98765432", "cdhs"
    
  attr_reader :cards
  
  def initialize
    build
    shuffle
  end
  
  def next_card
    @cards.pop
  end
  
  private
  
  def build
    @cards = []                            
    
    FACES.each_byte do |f|
      SUITS.each_byte {|s| @cards.push(f.chr + s.chr) }
    end
  end
  
  def shuffle
    3.times do                            
      shuf = []
      @cards.each do |c|
        loc = rand(shuf.size + 1)
        shuf.insert(loc, c)
      end
      @cards = shuf.reverse
    end
  end
end