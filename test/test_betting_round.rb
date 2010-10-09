require 'helper'

class BettingRoundTest < Test::Unit::TestCase
  include HandTestHelper
  
  def setup
    super
    @minimum_bet = 2.5
    @betting_round = BettingRound.new [@slim, @scotty, @doyle], @hand, @minimum_bet
    @hand.deal
  end                                    
                             
  test "player to the left of big blind is first to bet" do
    assert_equal @slim, @betting_round.next_player
  end                            
  
  test "play continues clockwise around the table" do
    assert_equal @slim, @betting_round.next_player
    assert_equal @scotty, @betting_round.next_player
    assert_equal @doyle, @betting_round.next_player 
    assert_equal @slim, @betting_round.next_player
  end
  
  test "betting continues clockwise around the table" do
    assert_equal @slim, @betting_round.current_player
    @betting_round.raise 20
    assert_equal @scotty, @betting_round.current_player
    @betting_round.raise 20
    assert_equal @doyle, @betting_round.current_player
  end
  
  test "should add raise to the pot" do
    @betting_round.raise 20
    assert_equal 20, @betting_round.pot
  end
                              
  test "should finish if all players check" do
    @betting_round.check
    @betting_round.check 
    @betting_round.check
    assert @betting_round.finished?
  end
  
  test "should finish if all players check or fold" do
    @betting_round.check 
    @betting_round.check
    @betting_round.fold
    assert @betting_round.finished?
  end
  
  test "should remove player from hand if they fold" do
    player = @betting_round.current_player
    @betting_round.fold
    assert_nil @hand.players.find {|p| p == player }
  end
  
  test "should finish when all but one fold" do
    @betting_round.fold
    @betting_round.fold
    assert @betting_round.finished?
  end
  
  test "should have minimum raise equal to big blind" do
    assert_block { @betting_round.raise(@minimum_bet) }
    assert_nil @betting_round.raise(@minimum_bet - 1)
  end
  
  test "betting finishes when everyone has put in equal amount" do
    @betting_round.players.size.times { @betting_round.raise 20 }
    assert @betting_round.finished?
  end
end
