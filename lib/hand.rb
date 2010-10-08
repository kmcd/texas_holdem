require 'enumerated_attribute'

class TexasHoldem::Hand
  enum_attr :round, %w( ^pocket flop turn river showdown )
  attr_reader :players, :community_cards
  
  def initialize(players)
    @players = players
    @deck = TexasHoldem::Deck.new
    @community_cards = []
  end
  
  def winner
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
  
  def deal_pocket_cards
    @players.each do |player| 
      2.times { player.cards << @deck.next_card }
    end
  end
  
  def deal_community_cards(number)
    number.times { @community_cards << @deck.next_card }
  end
end
