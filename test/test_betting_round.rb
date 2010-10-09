require 'helper'

class BettingRoundTest < Test::Unit::TestCase
  include HandTestHelper
  
  def setup
    super
    @betting_round = BettingRound.new [@slim, @scotty, @doyle]      
    @hand.deal
  end                                    
                             
  test "player to the left of big blind is first to bet" do
    assert_equal @slim, @betting_round.next_player
  end                            
  
  test "betting continues clockwise around the table" do
    assert_equal @slim, @betting_round.next_player
    assert_equal @scotty, @betting_round.next_player
    assert_equal @doyle, @betting_round.next_player 
    assert_equal @slim, @betting_round.next_player
  end                      
  
  test "should add raise to the pot" do
    @betting_round.raise @betting_round.next_player, 20
    assert_equal 20, @betting_round.pot
  end
                              
  test "should finish if all players check" do
    @betting_round.check @betting_round.next_player
    @betting_round.check @betting_round.next_player
    @betting_round.check @betting_round.next_player
    assert @betting_round.finished?
  end
end                                 
