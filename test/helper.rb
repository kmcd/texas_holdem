require 'rubygems'
require 'test/unit'
require 'active_support/testing/declarative'
require 'mocha'

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
  def self.factory(small_blind=1.25)
    players = %w( Slim Scotty Doyle ).map {|name| TexasHoldem::Player.factory name }
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
  def self.factory(name, cash=100)
    new name, cash
  end
end

module HandTestHelper
  def setup
    @hand = TexasHoldem::Hand.factory
    @slim, @scotty, @doyle = *@hand.players
  end
end
