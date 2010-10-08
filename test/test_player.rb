require 'helper'

class PlayerTest < Test::Unit::TestCase
  def setup
    @player = TexasHoldem::Player.new 'Doyle'
  end
  
  test "should have a name" do
    assert_equal 'Doyle', @player.name
  end
  
  test "should have no cards initially" do
    assert @player.cards.empty?
  end
end
