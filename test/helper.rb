require 'rubygems'
require 'test/unit'
require 'active_support/testing/declarative'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'texas_holdem'

class Test::Unit::TestCase
  extend ActiveSupport::Testing::Declarative
  
  def assert_cards(number,players)
    assert players.all? {|player| player.cards.size == number }
  end
end

class TexasHoldem::Hand
  def self.factory(number_of_players=3, small_blind=1.25)
    players = TexasHoldem::Player.factory number_of_players
    new players, small_blind
  end
  
  def advance_to_round(number)
    (number - 1).times do
      deal
      round_next
    end
  end
end

class TexasHoldem::Player
  def self.factory(number,cash=100)
    players = []
    number.times { players << new('player', cash) }
    players
  end
end

module HandTestHelper 
  def setup
    @hand = TexasHoldem::Hand.factory
    @scotty, @doyle, @slim = *@hand.players
  end
end
