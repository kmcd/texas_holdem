class BettingRound
  attr_reader :players
  
  def initialize(players,hand, minimum_bet)
    @players, @hand, @minimum_bet = players, hand, minimum_bet
    @bets, @betting_circle = [], @players.enum_for
    @players.each {|player| player.add_observer self }
  end
  
  def next_player
    @current_player = @betting_circle.next
    
    rescue StopIteration
      @betting_circle.rewind
      @betting_circle.next
  end
  
  def current_player
    @current_player || next_player
  end
  
  def pot
    bets.compact.reduce(:+) || 0
  end
  
  def players
    @players ||= @hand.players
  end
  
  def bets
    @bets ||= []
  end
  
  def finished?
    return true if only_one_player_remaining?
    all_remaining_bets_checked? || everyone_bet_equal_amount?
  end
  
  def update(args)
    if args[:fold]
      @players.delete current_player
      @hand.fold current_player
    else
      bet, player = args[:bet][:amount], args[:bet][:player] 
      return unless valid? bet, player
      bets << bet
    end
    next_player
  end
  
  private
  
  def valid?(bet,player)
    return unless player.eql? current_player
    bet >= @minimum_bet
  end
  
  def everyone_bet_equal_amount?
    remaining_players_last_bets.uniq.size == 1
  end
  
  def all_remaining_bets_checked?
    remaining_players_last_bets.all? {|bet| bet.nil? }
  end
  
  def remaining_players_last_bets
    bets[-@players.size..-1] || []
  end
  
  def only_one_player_remaining?
    @players.size == 1
  end
end
