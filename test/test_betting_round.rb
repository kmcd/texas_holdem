require 'helper'

class BettingRoundTest < Test::Unit::TestCase
  include HandTestHelper
  
  def setup
    super
    @betting_round = BettingRound.new @hand
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
    @betting_round.next_player
    assert_current_player @slim
  end
  
  test "should track amount bet" do
    @slim.bet 20
    assert_equal 20, @betting_round.amount_bet
    @scotty.bet 20
    assert_equal 40, @betting_round.amount_bet
    @doyle.bet 20
    assert_equal 60, @betting_round.amount_bet
  end
  
  test "should only accept bet from current player" do
    assert_current_player @slim
    @doyle.bet 20
    assert_equal 0, @betting_round.amount_bet
    assert_current_player @slim
  end
  
  test "should finish if all players check" do
    @betting_round.players.each {|player| player.check }
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
    @slim.bet @hand.minimum_bet - 1
    assert_equal 0, @betting_round.amount_bet
    assert_current_player @slim
  end
  
  test "betting finishes when everyone puts in same amount" do
    @betting_round.players.each {|player| player.bet 10 }
    assert @betting_round.finished?
  end
  
  test "should calculate minimum bet for current player" do
    @slim.bet 20
    
    assert_current_player @scotty
    assert_equal @betting_round.minimum_bet, 20
    @scotty.bet 30
    
    assert_current_player @doyle
    assert_equal @betting_round.minimum_bet, 30
    @doyle.bet 40
    
    assert_current_player @slim
    assert_equal @betting_round.minimum_bet, 20
    @slim.bet 20
    
    assert_current_player @scotty
    assert_equal @betting_round.minimum_bet, 10
    @scotty.bet 10
  end
  
  test "betting finishes when everyone matches amount previously put in" do
    @slim.bet 20
    @scotty.bet 30
    @doyle.bet 40
    assert !@betting_round.finished?
    @slim.bet 20
    assert !@betting_round.finished?
    @scotty.bet 10
    assert @betting_round.finished?
  end
  
  test "should enforce (big blind) minumim bet raise" do
    @slim.bet 10
    assert_equal 10, @betting_round.minimum_bet
    assert_equal 12.5, @betting_round.minimum_raise
    
    @scotty.bet 12
    assert_current_player @scotty
    
    @scotty.bet 12.5
    assert_current_player @doyle
  end
  
  test "should add bets to the pot" do
    @slim.bet 20
    @scotty.bet 20
    @doyle.bet 20
    blinds = 3.75
    assert_equal 60 + blinds, @hand.pot 
  end
  
  test "should kick player out of the hand if they take too long to bet" do
    @betting_round.max_wait_time_for_bet(0.09) do
      assert_current_player @slim
      sleep 0.1
      assert !@betting_round.players.include?(@slim)
      assert_current_player @scotty
    end
  end
end
