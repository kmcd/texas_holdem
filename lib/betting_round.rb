require 'timeout'

class BettingRound
  attr_accessor :max_wait_time_for_bet
  
  def initialize(hand)
    @hand = hand
    @betting_circle = players.enum_for
    players.each {|player| player.add_observer self }
  end
  
  def next_player
    @current_player = @betting_circle.next
    rescue StopIteration
      @betting_circle.rewind and retry
  end
  
  def max_wait_time_for_bet(seconds)
    Timeout::timeout(seconds) { yield }
    rescue Timeout::Error
      fold @current_player and next_player
  end
  
  def current_player
    @current_player || next_player
  end
  
  def players
    @players ||= @hand.players
  end
  
  def bets
    @bets ||= Hash.new(0)
  end
  
  def minimum_bet
    bets.values.empty? ? @hand.minimum_bet : amount_to_match_pot
  end
  
  def minimum_raise
    minimum_bet + @hand.minimum_bet
  end
  
  def amount_bet
    bets.values.compact.reduce(:+) || 0
  end
  
  def finished?
    players.size == 1 || everyone_bet_equal_amount? 
  end
  
  def update(args)
    if args[:fold]
      fold @current_player
    else
      bet, player = args[:bet][:amount], args[:bet][:player] 
      return unless valid? bet, player
      bets[player] += bet
      @hand.pot += bet
    end
    next_player
  end
  
  private
  
  def valid?(bet,player)
    return unless player.eql? current_player
    bet == minimum_bet || bet >= minimum_raise || bet == 0
  end
  
  def everyone_bet_equal_amount?
    bets.values.uniq.size == 1
  end
  
  def amount_to_match_pot
    bets.values.max - bets[current_player]
  end
  
  def fold(player)
    players.delete player
    @hand.fold player
  end
end
