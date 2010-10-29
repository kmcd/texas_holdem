# TODO: rename to PlayerHand or Player::Hand
class TexasHoldem::PlayersHand
  attr_reader :cards
  
  include Comparable
  
  # TODO: dry up [scdh] references
  MATCHES = { 
    'one pair'        => /(\d{1,2})[scdh] (?:\s\1[scdh]){1}/x,
    'two pair'        => /(\d{1,2})[scdh] \1[scdh].*(\d{1,2})[scdh] \2[scdh]/,
    'three of a kind' => /(\d{1,2})[scdh] (?:\s\1[scdh]){2}/x,
    'four of a kind'  => /(\d{1,2})[scdh] (?:\s\1[scdh]){3}/x,
  }                                                                           

  def initialize(cards)
    @cards = cards
    @cards.gsub!(/J/, '11')
    @cards.gsub!(/Q/, '12')
    @cards.gsub!(/K/, '13')
    @cards.gsub!(/A/, '14')
    @cards = @cards.split.sort_by {|c| c.gsub(/\D/,'').to_i }.join ' '
  end
  
  def <=>(players_hand)
    if score == players_hand.score
      remaining_cards <=> players_hand.remaining_cards
    else
      score <=> players_hand.score
    end
  end
                                  
  def name
    # TODO: refactor to polymorphic type?
    if four_of_a_kind?
      'four of a kind'
    elsif full_house?   
      'full house'
    elsif flush?
      'flush'
    elsif straight?
      'straight'
    elsif three_of_a_kind?
      'three of a kind'
    elsif two_pair?
      'two pair'
    elsif one_pair?
      'one pair'
    else
      'high card'
    end
  end
  
  def high_card?
    name == 'high card'
  end
  
  def one_pair?
    @cards.match MATCHES['one pair']
  end
  
  def two_pair?
    @cards.match MATCHES['two pair']
  end
  
  def straight?
    card_sequence = face_values.split.map {|d| d.to_i }
    (card_sequence.first..card_sequence.last).to_a == card_sequence
  end       
  
  def flush?
    @cards.match /\d{1,2}([csdh]) (?:\s\d{1,2}\1){4} /x
  end
  
  def three_of_a_kind?
    @cards.match MATCHES['three of a kind']
  end
  
  def full_house?
    # TODO: change this to [csdh]
    @cards.gsub(/\D/,'').match /^(?:(\d) \1{2} (\d) \2|(\d) \3 (\d) \4{2})/x
  end    
  
  def four_of_a_kind?
    @cards.match MATCHES['four of a kind']
  end
  
  protected
  
  def score
    base_score + relative_score
  end
  
  def base_score
    case name
      when /one pair/   : 1
      when /two pair/   : 2
      when /three/      : 3
      when /straight/   : 4
      when /flush/      : 5
      when /full house/ : 6
      when /four/       : 7
    else
      0
    end * 1000
  end
  
  def relative_score
    case name
      when /one pair/   : @cards[MATCHES['one pair'],1].to_i * 2
      when /two pair/   : @cards[MATCHES['two pair'],2].to_i * 2
      when /three/      : @cards[MATCHES['three of a kind'],1].to_i * 3
      when /straight/   : face_values.split.last.to_i
      when /flush/      : face_values.split.sort.last.to_i
      when /full house/ : @cards[MATCHES['three of a kind'],1].to_i
      when /four/       : @cards[MATCHES['four of a kind'],1].to_i
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
  
  private
  
  def face_values
    @cards.gsub(/[scdh]/,'')
  end
end
