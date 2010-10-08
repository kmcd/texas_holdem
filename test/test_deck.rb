require 'helper'

SORTED_FULL_DECK = %w[ 2c 2d 2h 2s 3c 3d 3h 3s 4c 4d 4h 4s 5c 5d 5h 5s 6c 6d 6h 6s 
  7c 7d 7h 7s 8c 8d 8h 8s 9c 9d 9h 9s Ac Ad Ah As Jc Jd Jh Js Kc Kd Kh Ks Qc
  Qd Qh Qs Tc Td Th Ts]
    
class NewDeckTest < Test::Unit::TestCase
  def setup
    @deck = TexasHoldem::Deck.new
  end
  
  test "should have 52 cards initially" do
    assert_equal 52, @deck.cards.size
  end
  
  test "should have 52 unique cards" do
    assert_equal 52, @deck.cards.uniq.size
  end
  
  test "should have 2 - Ace of Clubs, Spades, Diamonds & Hearts" do
    assert_equal SORTED_FULL_DECK, @deck.cards.sort
  end
end

class DeckDealTest < Test::Unit::TestCase
  def setup
    @deck = TexasHoldem::Deck.new
  end
  
  test "should deal the next card" do
    delt_card = @deck.next_card
    
    assert_equal 51, @deck.cards.size
    assert SORTED_FULL_DECK.include?(delt_card)
    assert_equal SORTED_FULL_DECK - [delt_card], @deck.cards.sort
  end
end