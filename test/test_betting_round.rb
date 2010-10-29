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
    assert_current_player @amy
  end
  
  test "play continues clockwise around the table" do
    assert_current_player @amy
    @betting_round.next_player
    assert_current_player @bill
    @betting_round.next_player
    assert_current_player @carl
    @betting_round.next_player
    assert_current_player @amy
  end
  
  test "should track amount bet" do
    @amy.bet 20
    assert_equal 20, @betting_round.amount_bet
    @bill.bet 20
    assert_equal 40, @betting_round.amount_bet
    @carl.bet 20
    assert_equal 60, @betting_round.amount_bet
  end
  
  test "should only accept bet from current player" do
    assert_current_player @amy
    @carl.bet 20
    assert_equal 0, @betting_round.amount_bet
    assert_current_player @amy
  end
  
  test "should finish if all players check" do
    @betting_round.players.each {|player| player.check }
    assert @betting_round.finished?
  end
  
  test "should finish if all players check or fold" do
    @amy.check
    @bill.check
    @carl.fold
    assert @betting_round.finished?
  end
  
  test "should remove player from hand if they fold" do
    player = @betting_round.current_player
    player.fold
    assert_nil @hand.players.find {|p| p == player }
  end
  
  test "should finish when all but one fold" do
    @amy.fold
    @carl.fold
    assert @betting_round.finished?
  end
  
  test "should have minimum raises equal to big blind" do
    @amy.bet @hand.minimum_bet - 1
    assert_equal 0, @betting_round.amount_bet
    assert_current_player @amy
  end
  
  test "betting finishes when everyone puts in same amount" do
    @betting_round.players.each {|player| player.bet 10 }
    assert @betting_round.finished?
  end
  
  test "should calculate minimum bet for current player" do
    @amy.bet 20
    
    assert_current_player @bill
    assert_equal @betting_round.minimum_bet, 20
    @bill.bet 30
    
    assert_current_player @carl
    assert_equal @betting_round.minimum_bet, 30
    @carl.bet 40
    
    assert_current_player @amy
    assert_equal @betting_round.minimum_bet, 20
    @amy.bet 20
    
    assert_current_player @bill
    assert_equal @betting_round.minimum_bet, 10
    @bill.bet 10
  end
  
  test "betting finishes when everyone matches amount previously put in" do
    @amy.bet 20
    @bill.bet 30
    @carl.bet 40
    assert !@betting_round.finished?
    @amy.bet 20
    assert !@betting_round.finished?
    @bill.bet 10
    assert @betting_round.finished?
  end
  
  test "should enforce (big blind) minumim bet raise" do
    @amy.bet 10
    assert_equal 10, @betting_round.minimum_bet
    assert_equal 12.5, @betting_round.minimum_raise
    
    @bill.bet 12
    assert_current_player @bill
    
    @bill.bet 12.5
    assert_current_player @carl
  end
  
  test "should add bets to the pot" do
    @amy.bet 20
    @bill.bet 20
    @carl.bet 20
    blinds = 3.75
    assert_equal 60 + blinds, @hand.pot 
  end
  
  test "should kick player out of the hand if they take too long to bet" do
    @betting_round.max_wait_time_for_bet(0.09) do
      assert_current_player @amy
      sleep 0.1
      assert !@betting_round.players.include?(@amy)
      assert_current_player @bill
    end
  end
end
