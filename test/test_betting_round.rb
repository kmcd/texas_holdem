require 'helper'

class BettingRoundTest < Test::Unit::TestCase
  include HandTestHelper
  
  def setup
    super
    @betting_round = BettingRound.new [@slim, @scotty, @doyle]
  end                                    
                             
  test "player to the left of big blind is first to bet" do
    @hand.deal
    assert_equal @slim, @betting_round.next_player
  end                            
  
  test "betting continues clockwise around the table" do
    @hand.deal
    assert_equal @slim, @betting_round.next_player
    assert_equal @scotty, @betting_round.next_player
    assert_equal @doyle, @betting_round.next_player 
    assert_equal @slim, @betting_round.next_player
  end                      
  
  test "first bet must be equal or greater than big blind amount" do
    # flunk   
  end
end                                 
