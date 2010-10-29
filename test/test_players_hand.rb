require 'helper'

class HandTest < Test::Unit::TestCase
  test "should always have cards sorted in ascending order by face value" do
    hand = TexasHoldem::PlayersHand.new('Ad As 5c 6c Jd')
    assert_equal  "5c 6c 11d 14s 14d", hand.cards
  end
end

class HandIdentificationTest < Test::Unit::TestCase
  # TODO: add more non-sequential matches
  
  test "should recognise a pair" do
    '2d 2s 5c 6c Ad'.hand_name 'one pair'
  end
  
  test "should recognise two pair" do
    '2d 2s 5c 5d Ad'.hand_name 'two pair'
  end
  
  test "should recognise three of a kind" do
    '2d 2s 2h 5d Ad'.hand_name 'three of a kind' 
  end
  
  test "should recognise a straight" do
    '2d 3s 4h 5d 6d'.hand_name 'straight'
  end
  
  test "should recognise a full house" do
    '2d 2s 2h 4d 4c'.hand_name 'full house'
    '2d 2s 4h 4d 4c'.hand_name 'full house'
    '2d 4s 2h 4d 4c'.hand_name 'full house'
  end
end

class WinningHandsTest < Test::Unit::TestCase
  test "highest card should win if no scoring poker hands" do
    '2d 3s 5c 6c Ad'.beats '2c 3d 5s 6h Kd'
  end
  
  test "one pair beats no matches" do
    '2d 2s 5c 6c Ad'.beats '2c 3d 5s 6h Kd'
  end
  
  test "high pair beats low pair" do
    'Ad As 5c 6c Jd'.beats 'Kc Kd 5s 6h Qd'
  end
  
  test "highest card wins when pairs are equal" do
    'Ad As 5c 6c Kd'.beats 'Ac Ad 5s 6h Qd'
  end
  
  test "two pair beats a pair" do
    'Ad As 5c 5d Kd'.beats 'Ac Ad 5s 6h Qd'
  end
  
  test "three of a kind beats two pair" do
    'Ad As Ac 5d Kd'.beats 'Kc Kd 5s 5h Qd'
  end
end