require 'helper'

class GameTest < Test::Unit::TestCase
  def setup
    @game = TexasHoldem::Game.new [], 100
  end
  
  test "should not have a winner at game start" do
    assert_nil @game.winner
  end
  
  test "should have players" do
    assert_equal [], @game.players
  end
  
  test "should have small blind as 1.25% of entrance fee" do
    assert_equal 1.25, @game.small_blind
  end
  
  test "should know when finshed" do
    @game.stubs(:players).returns [TexasHoldem::Player.new('Foo', 100)]
    assert_equal true, @game.finished?
  end
  
  test "should have a winner when finished" do
    winner = TexasHoldem::Player.new 'Foo', 100
    @game.stubs(:players).returns [winner]
    assert_equal winner, @game.winner
  end
end
