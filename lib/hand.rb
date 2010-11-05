require 'enumerated_attribute'

class TexasHoldem::Hand
  enum_attr :round, %w( ^pocket flop turn river showdown )
  attr_reader :players, :community_cards
  attr_accessor :pot
  
  def initialize(players, small_blind_amount=1)
    @players = players
    @deck = TexasHoldem::Deck.new
    @community_cards = []
    @small_blind_amount = small_blind_amount
    @pot = 0 # Should this be an Observer?
  end
  
  def dealer
    @players.first
  end
  
  def minimum_bet
    @small_blind_amount * 2
  end
  
  def small_blind
    return dealer if players_remaining? 2
    @players[2]
  end
  
  def big_blind
    return @players.last if players_remaining? 2
    @players[1]
  end
  
  def winner
    return unless finished?
    winning_player = @players.first
    winning_player.take_winnings @pot
    winning_player
  end
  
  def finished?
    players_remaining? 1
  end
  
  def fold(player)
    @players.delete player
  end
  
  def deal
    case round
      when :pocket : deal_pocket_cards && deduct_blinds
      when :flop   : deal_community_cards 3
      when :turn   : deal_community_cards 1
      when :river  : deal_community_cards 1
    end
  end
  
  private
  
  def players_remaining?(number)
    @players.size == number
  end
  
  def deal_pocket_cards
    @players.each do |player| 
      2.times { player.cards << @deck.next_card }
    end
  end
  
  def deal_community_cards(number)
    number.times { @community_cards << @deck.next_card }
  end
  
  def deduct_blinds
    @pot += small_blind.bet(@small_blind_amount)
    @pot += big_blind.bet(@small_blind_amount * 2)
  end
end
