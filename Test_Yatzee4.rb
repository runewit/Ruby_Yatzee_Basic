require "./Yatzee4.rb"
require "test/unit"
class Test_yatzee < Test::Unit::TestCase
  def setup
    @game_sheet=Game_sheet.new(:name => "Jared", :slot => "1", :section => "upper", :score => "70")
    @dice_set=Dice_set.new(:dice_scores => "")
    #@game=Game.new
    #@mothership=Mothership.new
  end
  def test_dice_roll_outcome
    assert_kind_of(Array, @dice_set.dice_scores)
    @dice_set.reset
    @dice_set.roll_dice
    assert_includes(1..6, @dice_set.dice_scores[1])
  end
  def test_sheet # Game_sheet is super hard to test because it all relies on the hash @data that is floating around.
=begin
    Running a test like this should be able to check to see if it entered the score into the proper place and using the proper score
    It doesn't work I think because I would need a rediculous amout of setup (essentially the whole class) to make it work
    
    Example tests:
    
    @game_sheet.enter_score(2)
    assert_equal("70", @game_sheet.upper_section[0][1])
    
    @game_sheet.set_slot(7)
    assert_equal(7,@slot)
=end
    assert_kind_of(Integer,@game_sheet.calculate_lower_score) # if I had time, I might be able to set some defaults for testing, but that is not an easy thing how this program is right now
  end
  def test_game # the Game class is mostly interface between the user and the dice/sheet and the rules for how dice and sheet interact, this stuff is also very hard to test.
  end
  def test_mothership # all the methods in Mothership have to do with Gosu and graphics, and therefore can't be tested. I have to manually test it through playing the game.
  end
end

# Game and Mothership can't be tested as my program stands right now because they interfere with eachother's interface.  Game sits at command prompt waiting for a response while Mothership waits for an interaction in the window.  ideally, if I had another couple weeks to turn this in, I would have merged Game and Mothership because they are both interface to the user.