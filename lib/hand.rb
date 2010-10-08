require 'enumerated_attribute'

class TexasHoldem::Hand
  enum_attr :round, %w( ^pocket flop turn river showdown )
  attr_reader :players, :community_cards
  
  def initialize(players,blind_amount=1)
    @players = players
    @deck = TexasHoldem::Deck.new
    @community_cards = []
  end
  
  def dealer
    @players.first
  end
  
  def small_blind
    return dealer if two_player_game?
    @players[2]
  end
  
  def big_blind
    return @players.last if two_player_game?
    @players[1]
  end
  
  def winner
  end
  
  def betting_round
    players.each do |player| 
      player.place_bet minimum_raise
    end
  end
  
  def minimum_raise
  end
  
  def deal
    case round
      when :pocket : deal_pocket_cards
      when :flop   : deal_community_cards 3
      when :turn   : deal_community_cards 1
      when :river  : deal_community_cards 1
    end
  end
  
  private
  
  def two_player_game?
    @players.size == 2
  end
  
  def deal_pocket_cards
    @players.each do |player| 
      2.times { player.cards << @deck.next_card }
    end
  end
  
  def deal_community_cards(number)
    number.times { @community_cards << @deck.next_card }
  end
end
