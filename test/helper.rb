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
