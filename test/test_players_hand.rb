require 'helper'

class HandTest < Test::Unit::TestCase
  test "should always have cards sorted in ascending order by face value" do
    hand = TexasHoldem::PlayersHand.new('Ad As 5c 6c Jd')
    assert_equal  "5c 6c 11d 14s 14d", hand.cards
  end
end

class HandIdentificationTest < Test::Unit::TestCase
  # TODO: add more non-sequential matches
  
  test "should recognise a high card" do
    '2d 3s 5c 6c Ad'.hand_name 'high card'
  end
  
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
    '10c Jd Qs Kd As'.hand_name 'straight'
  end
  
  test "should recognise a flush" do
    '2h 3h 4h 5h 7h'.hand_name 'flush'
  end
  
  test "should recognise a full house" do
    '2d 2s 2h 4d 4c'.hand_name 'full house'
    '2d 2s 4h 4d 4c'.hand_name 'full house'
    '2d 4s 2h 4d 4c'.hand_name 'full house'
  end
  
  test "should recognise four of a kind" do
    '2d 2c 2s 2h 3c'.hand_name 'four of a kind'
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
  
  test "highest pair wins if both two pairs" do
    '2d 2s 4c 4d Kd'.beats '2c 2d 3s 3h Qd'
    'Ad As 4c 4d Kd'.beats 'Kc Kd Qs Qh Jd'
  end
  
  test "highest card wins if both hands have identincal two pairs" do
    '2d 2s 4c 4d 6d'.beats '2d 2s 4c 4d 5d'
  end
  
  test "three of a kind beats two pair" do
    'Ad As Ac 5d Kd'.beats 'Kc Kd 5s 5h Qd'
  end
  
  test "stright beats three of a kind" do
    '2d 3c 4h 5s 6d'.beats 'Ad As Ac 5d Kd'
  end
  
  test "higher stright beats lower straight" do
    '3c 4h 5s 6d 7d'.beats '2d 3c 4h 5s 6d'
    '10c Jd Qs Kd As'.beats '9h 10c Jd Qs Kd'
  end
  
  test "flush beats a straight" do
    '2h 3h 4h 5h 7h'.beats '9h 10c Jd Qs Kd'
  end
  
  test "high card determines winner of flushes" do
    '2h 3h 4h 5h 8h'.beats '2d 3d 4d 5d 7d'
  end
  
  test "full house beats a flush" do
    '2d 2s 2h 4d 4c'.beats '2d 3d 4d 5d 7d'
  end
  
  test "higher three of a kind determines full house winner" do
    '3d 3s 3h 4d 4c'.beats '2s 2h 2c Ad Ac'
    'Ad As Ah 4d 4c'.beats 'Ks Kh Kc Ad Ac'
  end
  
  test "four of a kind beats a full house" do
    '2d 2c 2s 2h 3c'.beats '3d 3s 3h 4d 4c'
  end
  
  test "higher card determines four of a kind winner" do
    '3d 3c 3s 3h 4c'.beats '2d 2c 2s 2h 5c'
    'Ad Ac As Ah 4c'.beats 'Kd Kc Ks Kh 5c'
  end
end