require 'helper'

class PlayerTest < Test::Unit::TestCase
  def setup
    @entrance_fee = 100
    @player = TexasHoldem::Player.new 'Carl', @entrance_fee
  end
  
  test "should have a name" do
    assert_equal 'Carl', @player.name
  end
  
  test "should have no cards initially" do
    assert @player.cards.empty?
  end
  
  test "should have cash" do
    assert_equal @entrance_fee, @player.cash
  end
  
  test "should place a bet" do
    @player.bet 99
    assert_equal 1, @player.cash
  end
  
  test "should NOT bet more than available cash" do
    # FIXME: treat as all in insead of raising an error
    assert_raises(NotEnoughCashError) do
      @player.bet(101)
    end
  end
end
