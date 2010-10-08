require 'helper'

class TexasHoldem::Hand
  def advance_to_round(number)
    (number - 1).times do
      deal
      round_next
    end
  end
end

class HandTest < Test::Unit::TestCase
  include TexasHoldem
  
  def setup
    @scotty = Player.new 'Scotty'
    @doyle = Player.new 'Doyle'
    @slim = Player.new 'Amarillo Slim'
    @hand = Hand.new [@scotty, @doyle, @slim]
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
  
  test "should have a dealer" do
    assert_equal @scotty, @hand.dealer
  end
  
  test "should have a big blind player" do
    assert_equal @doyle, @hand.big_blind
  end
  
  test "should have a small blind player" do
    assert_equal @slim, @hand.small_blind
  end
end

class FlopHandTest < HandTest
  def setup
    super
    @hand.advance_to_round 2
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
    @hand.advance_to_round 3
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
    @hand.advance_to_round 4
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

class TwoPlayerHandTest < HandTest
  include TexasHoldem
  
  def setup
    super
    @hand = Hand.new [@scotty, @doyle]
  end
  
  test "should have the dealer as the small blind" do
    assert_equal @hand.dealer, @scotty
    assert_equal @hand.small_blind, @scotty
  end
  
  test "should have second player as big blind" do
    assert_equal @hand.big_blind, @doyle
  end
end

class BettingRoundTest < HandTest
  test "should have a round of betting" do
    @hand.deal
    @hand.betting_round
  end
end


