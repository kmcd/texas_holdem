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
    
    FACES.each_byte do |face|
      SUITS.each_byte {|suit| @cards.push(face.chr + suit.chr) }
    end
  end
  
  def shuffle
    3.times do                            
      shuf = []
      @cards.each do |card|
        loc = rand(shuf.size + 1)
        shuf.insert(loc, card)
      end
      @cards = shuf.reverse
    end
  end
end