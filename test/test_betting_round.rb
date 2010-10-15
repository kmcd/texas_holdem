require 'helper'

class BettingRoundTest < Test::Unit::TestCase
  include HandTestHelper
  
  def setup
    super
    @minimum_bet = 2.5
    # TODO: decouple Players by passing in Hand only
    @betting_round = BettingRound.new [@slim, @scotty, @doyle], @hand, @minimum_bet
    @hand.deal
  end
  
  def assert_current_player(player)
    assert_equal player, @betting_round.current_player
  end
                             
  test "player to the left of big blind is first to bet" do
    assert_current_player @slim
  end
  
  test "play continues clockwise around the table" do
    assert_current_player @slim
    @betting_round.next_player
    assert_current_player @scotty
    @betting_round.next_player
    assert_current_player @doyle
  end
  
  test "should add bets to the pot" do
    @slim.bet 20
    assert_equal 20, @betting_round.pot
    @scotty.bet 20
    assert_equal 40, @betting_round.pot
    @doyle.bet 20
    assert_equal 60, @betting_round.pot
  end
  
  test "should only accept bet from current player" do
    assert_current_player @slim
    @doyle.bet 20
    assert_equal 0, @betting_round.pot
    assert_current_player @slim
  end
  
  test "should finish if all players check" do
    @slim.check
    @scotty.check
    @doyle.check
    assert @betting_round.finished?
  end
  
  test "should finish if all players check or fold" do
    @slim.check 
    @scotty.check
    @doyle.fold
    assert @betting_round.finished?
  end
  
  test "should remove player from hand if they fold" do
    player = @betting_round.current_player
    player.fold
    assert_nil @hand.players.find {|p| p == player }
  end
  
  test "should finish when all but one fold" do
    @slim.fold
    @doyle.fold
    assert @betting_round.finished?
  end
  
  test "should have minimum raises equal to big blind" do
    @slim.bet @minimum_bet - 1
    assert_equal 0, @betting_round.pot
    assert_current_player @slim
  end
  
  test "betting finishes when everyone has put in same amount" do
    @betting_round.players.each {|player| player.bet 10 }
    assert @betting_round.finished?
  end
end
