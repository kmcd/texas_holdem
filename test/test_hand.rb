require 'helper'

def advance_to_round(number, hand)
  (number - 1).times do
    hand.deal
    hand.round_next
  end
end

class HandTest < Test::Unit::TestCase
  include TexasHoldem
  
  def setup
    @hand = Hand.new [Player.new, Player.new]
  end
  
  test "should not have a winner initially" do
    assert_nil @hand.winner
  end
end

class PocketHandTest < HandTest
  test "first round should be pocket/hole cards" do
    assert @hand.pocket?
  end
  
  test "first round should deal two cards to all players" do
    @hand.deal
    assert_cards 2, @hand.players
  end
end

class FlopHandTest < HandTest
  def setup
    super
    advance_to_round 2, @hand
    @hand.deal
  end
  
  test "second round should be the flop" do
    assert @hand.flop?
  end
  
  test "second round should deal no new cards to any players" do
    assert_cards 2, @hand.players
  end
  
  test "second round should deal three community cards" do
    assert_equal 3, @hand.community_cards.size
  end
end

class TurnHandTest < HandTest
  def setup
    super
    advance_to_round 3, @hand
    @hand.deal
  end
  
  test "third round should be the turn" do
    assert @hand.turn?
  end
  
  test "third round should deal no new cards to any players" do
    assert_cards 2, @hand.players
  end
  
  test "second round should deal one extra community card" do
    assert_equal 4, @hand.community_cards.size
  end
end

class RiverHandTest < HandTest
  def setup
    super
    advance_to_round 4, @hand
    @hand.deal
  end
  
  test "third round should be the river" do
    assert @hand.river?
  end
  
  test "third round should deal no new cards to any players" do
    assert_cards 2, @hand.players
  end
  
  test "second round should deal one extra community card" do
    assert_equal 5, @hand.community_cards.size
  end
end
