require 'pp'

class TexasHoldem::PlayersHand
  include Comparable
  
  MATCHES = { 
    'one pair'        => /(\d{1,2})\w \1\w/, 
    'two pair'        => /(\d{1,2})\w \1\w.*(\d{1,2})\w \2\w/,
    'three of a kind' => /(\d{1,2})\w \1\w \1\w/,
    
    # OK, this is a bit crazy but straights are the hardest to match
    # It works by building all combinations of possible straights 
    'straight'        => Regexp.new( (0..8).map {|s| (2..14).to_a[ s..s+4 ].join ' ' }.map {|s| s.gsub /(\d{1,2})/,'\1\w' }.join('|').sub(/^/,'(').sub(/$/,')') )
  }
  
  def initialize(cards)
    @cards = cards
    @cards.gsub!(/J/, '11')
    @cards.gsub!(/Q/, '12')
    @cards.gsub!(/K/, '13')
    @cards.gsub!(/A/, '14')
    @cards.split.sort.join ' '
  end
  
  def <=>(players_hand)
    if score == players_hand.score
      remaining_cards <=> players_hand.remaining_cards
    else
      score <=> players_hand.score
    end
  end
  
  def name
    # TODO: remove regex/name duplication
    @name ||= case @cards
    when MATCHES['straight']        : 'straight'
    when MATCHES['three of a kind'] : 'three of a kind'
    when MATCHES['two pair']        : 'two pair'
    when MATCHES['one pair']        : 'one pair'
    else
      'high card'
    end
  end
  
  def pretty_print(printer)
    printer.text [ @cards,  name, score ].join " | "
  end
  
  protected
  
  def score
    base_score + relative_score
  end
  
  def base_score
    case name
    when /one pair/ : 1
    when /two pair/ : 2
    when /three/    : 3
    else
      0
    end * 1000
  end
  
  def relative_score
    case name
    when /one pair/ : @cards[MATCHES['one pair'],1].to_i * 2
    when /two pair/ : @cards[MATCHES['two pair'],1].to_i * 2 + @cards[MATCHES['two pair'],2].to_i * 2
    when /three/    : @cards[MATCHES['three of a kind'],1].to_i * 3
    else
      0
    end
  end
  
  def remaining_cards
    case name
      when /high card/ : @cards
      when /one pair/  : @cards.gsub(MATCHES['one pair'], '')
      when /two pair/  : @cards.gsub(MATCHES['two pair'], '')
      else
        ''
    end.gsub /[a-z]/, ''
  end
end
