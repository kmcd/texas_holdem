require 'helper'

class GameTest < Test::Unit::TestCase
  def setup
    @game = TexasHoldem::Game.new [], 100
  end
  
  test "should not have a winner at game start" do
    assert_nil @game.winner
  end
  
  test "should have a buy-in fee" do
    assert_equal (@game.entrance_fee * @game.players.size), @game.pot
  end
  
  test "should have players" do
    assert_equal [], @game.players
  end
end
