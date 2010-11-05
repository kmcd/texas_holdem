module TexasHoldem
  class PlayerHand
    attr_reader :cards
    include Comparable
    
    def self.inherited(subclass)
      (@hand_types || @hand_types = []) << subclass
    end
    
    # TODO: investigate Builder / Factory pattern
    def self.create(cards)
      # cards could be both OnePair and a FullHouse, so return the highest raking hand
      @hand_types.map {|hand| hand.create(cards) }.compact.sort_by(&:score).last
    end
    
    def initialize(cards)
      @cards = cards
      @cards.gsub!(/J/, '11')
      @cards.gsub!(/Q/, '12')
      @cards.gsub!(/K/, '13')
      @cards.gsub!(/A/, '14')
      @cards = @cards.split.sort_by {|card| card.gsub(/\D/,'').to_i }.join ' '
    end
    
    def <=>(players_hand)
      other_players_hand_score = players_hand.score
      this_players_score = score
      
      if this_players_score == other_players_hand_score
        remaining_cards <=> players_hand.remaining_cards
      else
        this_players_score <=> other_players_hand_score
      end
    end
    
    def score
      base_score * 1000 + relative_score
    end
    
    def remaining_cards
      @cards.gsub /\D/, ''
    end
    
    private
    
    def face_values
      @cards.gsub(/[scdh]/,'')
    end
    
    def face_values_array
      face_values.to_a
    end
  end
    
  class FourOfAKind < PlayerHand
    Pattern = /(\d{1,2})[scdh] (?:\s\1[scdh]){3}/x
    
    def self.create(cards)
      new cards if cards.match Pattern
    end
    
    def name
      'four of a kind'
    end
    
    def base_score
      7
    end
    
    def relative_score
      @cards[Pattern,1].to_i
    end
  end
  
  class FullHouse < PlayerHand
    Pattern =  /^(?:(\d) \1{2} (\d) \2|(\d) \3 (\d) \4{2})/x
    
    def self.create(cards)
      new(cards) if cards.gsub(/\D/,'').split(//).sort.to_s.match Pattern
    end
    
    def name
      'full house'
    end
    
    def base_score
      6
    end
    
    def relative_score
      @cards[ TexasHoldem::ThreeOfAKind::Pattern, 1 ].to_i
    end
  end
  
  class Flush < PlayerHand
    Pattern = /\d{1,2}([csdh]) (?:\s\d{1,2}\1){4} /x
    
    def self.create(cards)
      new(cards) if cards.match Pattern
    end
    
    def name
      'flush'
    end
    
    def base_score
      5
    end
    
    def relative_score
      face_values_array.sort.last.to_i
    end
  end
  
  class Straight < PlayerHand
    def self.create(cards)
      straight = new cards
      card_values = straight.cards.gsub(/[scdh]/,'').split.map {|card_value| card_value.to_i }
      new(cards) if (card_values.first..card_values.last).to_a == card_values
    end
    
    def name
      'straight'
    end
    
    def base_score
      4
    end
    
    def relative_score
      face_values_array.last.to_i
    end
  end
  
  class ThreeOfAKind < PlayerHand
    Pattern = /(\d{1,2})[scdh] (?:\s\1[scdh]){2}/x
    
    def self.create(cards)
      new(cards) if cards.match Pattern
    end
    
    def name
      'three of a kind'
    end
    
    def base_score
      3
    end
    
    def relative_score
      @cards[ Pattern, 1 ].to_i
    end
  end
  
  class TwoPair < PlayerHand
    Pattern = /(\d{1,2})[scdh] \1[scdh].*(\d{1,2})[scdh] \2[scdh]/
    
    def self.create(cards)
      new(cards) if cards.match Pattern
    end
    
    def name
      'two pair'
    end
    
    def base_score
      2 
    end
    
    def relative_score
      @cards[ Pattern , 2 ].to_i * 2
    end
    
    def remaining_cards
      @cards.gsub(Pattern, '').gsub /\D/, ''
    end
  end
  
  class OnePair < PlayerHand
    Pattern = /(\d{1,2})[scdh] (?:\s\1[scdh]){1}/x
    
    def self.create(cards)
      new(cards) if cards.match Pattern
    end
    
    def name
      'one pair'
    end
    
    def base_score
      1
    end
    
    def relative_score
      @cards[ Pattern , 1 ].to_i * 2
    end
    
    def remaining_cards
      @cards.gsub(Pattern, '').gsub /\D/, ''
    end
  end
  
  class HighCard < PlayerHand
    def self.create(cards)
      new(cards)
    end
    
    def name
      'high card'
    end
    
    def base_score
      0
    end
    
    def relative_score
      0
    end
  end
end
