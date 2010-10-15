require 'helper'

class HandTest < Test::Unit::TestCase  
  include HandTestHelper
  
  test "should not have a winner initially" do
    assert_nil @hand.winner
  end
  
  test "should have a winner if everyone else folds" do
    @hand.deal
    @hand.fold @scotty
    @hand.fold @doyle
    
    assert_equal @hand.winner, @slim
  end
                 
  test "automatically deduct blinds after dealing pocket cards" do
    assert_equal 100, @hand.small_blind.cash
    assert_equal 100, @hand.big_blind.cash
    
    @hand.deal
    
    assert @hand.pocket?
    assert_equal 98.75, @hand.small_blind.cash
    assert_equal 97.5, @hand.big_blind.cash
    assert_equal 2.5 + 1.25, @hand.pot
  end
  
  test "pay out winnings when only one player remains" do
    @hand.deal
    @hand.fold @hand.small_blind
    @hand.fold @hand.big_blind
    
    assert_equal 103.75, @hand.winner.cash
  end
  
  test "minimum bet is double the small blind" do
    assert_equal 2.5, @hand.minimum_bet
  end
end

class PocketHandTest < Test::Unit::TestCase  
  include HandTestHelper
  
  test "first round should be pocket/hole cards" do
    assert @hand.pocket?
  end
  
  test "first round should deal two cards to all players" do
    @hand.deal
    assert_cards 2, @hand.players
  end
  
  test "should have a dealer" do
    assert_equal @slim, @hand.dealer
  end
  
  test "should have a big blind player" do
    assert_equal @scotty, @hand.big_blind
  end
  
  test "should have a small blind player" do
    assert_equal @doyle, @hand.small_blind
  end
end     

class FlopTest < Test::Unit::TestCase 
  include HandTestHelper
  
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

class TurnTest < Test::Unit::TestCase 
  include HandTestHelper
  
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
                         
class RiverTest < Test::Unit::TestCase 
  include HandTestHelper
  
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

class TwoPlayerHandTest < Test::Unit::TestCase
  include HandTestHelper
  
  def setup
    super
    @hand = TexasHoldem::Hand.new [@scotty, @doyle]
  end
                                                              
  test "should have the dealer as the small blind" do       
    assert_equal @hand.dealer, @scotty
    assert_equal @hand.small_blind, @scotty
  end              
  
  test "should have second player as big blind" do
    assert_equal @hand.big_blind, @doyle
  end
end
