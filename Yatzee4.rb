require 'gosu'
class Mothership < Gosu::Window
  def initialize
    super(800,600,false)
    self.caption="Yatzee"
    @die_face=[]
    @die_face[1]=Gosu::Image.new(self,"die1.png",false)
    @die_face[2]=Gosu::Image.new(self,"die2.png",false)
    @die_face[3]=Gosu::Image.new(self,"die3.png",false)
    @die_face[4]=Gosu::Image.new(self,"die4.png",false)
    @die_face[5]=Gosu::Image.new(self,"die5.png",false)
    @die_face[6]=Gosu::Image.new(self,"die6.png",false)
    @roll_animation=0
    @roll_phase=true
    @chosen_dice=""
    Game.new
  end
  def needs_cursor?
    true
  end # I need to see where I'm clicking
  def animation_for_rolling_die(die)
    return if die==""
    @dice_set.set_reroll(die)
    @roll_animation=15
  end # aesthetic, has no real function
  def in_dice_row(y_coord)
    (525..575).cover?(y_coord)
  end
  def in_button_row(x_coord)
    (400..500).cover?(x_coord)
  end
  def which_die(x_coord)
    case x_coord
    when 415..465 # die 1 range
      @chosen_dice+="1"
    when 495..545 # die 2 range
      @chosen_dice+="2"
    when 575..625 # die 3 range
      @chosen_dice+="3"
    when 655..705 # die 4 range
      @chosen_dice+="4"
    when 735..785 # die 5 range
      @chosen_dice+="5"
    else
      @chosen_dice+=""
    end
  end
  def which_button(x_coord)
    case x_coord
    when 400..532
      animation_for_rolling_die(@chosen_dice)
      puts @chosen_dice
      @chosen_dice=""
      puts @chosen_dice
    end
  end
  def in_score_slot_column(x_coord)
    (355..380).cover?(x_coord)
  end
  def which_slot(y_coord)
    case y_coord
    when 20..45
      # give game a "upper" for section and a "1" for slot
    when 50..75
      # give game a "upper" for section and a "2" for slot
    when 80..105
      # give game a "upper" for section and a "3" for slot
    when 110..135
      # give game a "upper" for section and a "4" for slot
    when 140..165
      # give game a "upper" for section and a "5" for slot
    when 170..195
      # give game a "upper" for section and a "6" for slot
    when 200..225
      # blank for upper_score
    when 230..255
      # give game a "lower" for section and a "1" for slot
    when 260..285
      # give game a "lower" for section and a "2" for slot
    when 290..315
      # give game a "lower" for section and a "3" for slot
    when 320..345
      # give game a "lower" for section and a "4" for slot
    when 350..375
      # give game a "lower" for section and a "5" for slot
    when 380..405
      # give game a "lower" for section and a "6" for slot
    when 410..435
      # give game a "lower" for section and a "7" for slot
    when 440..465
      # blank for lower_score
    when 470..495
      # blank for total_score
    end
  end
  def handle_mouse_click
    if @roll_phase==true
      if in_dice_row(mouse_y)
        which_die(mouse_x)
      elsif in_button_row(mouse_y)
        which_button(mouse_x)
      end
    else #@roll_phase==false
      if in_score_slot_column(mouse_x)
        which_slot(mouse_y)
      end
    end
  end
  def box_for_score(box_number)
    draw_quad(355,20+box_number*30,0xffffffff,380,20+box_number*30,0xffffffff,355,45+box_number*30,0xffffffff,380,45+box_number*30,0xffffffff)
    draw_quad(356,21+box_number*30,0xff000000,379,21+box_number*30,0xff000000,356,44+box_number*30,0xff000000,379,44+box_number*30,0xff000000)
  end
  def unpack_info_for_gosu
    @dice_set=Game.info_for_gosu[:dice]
  end
  def button_down(id)
    case id
    when Gosu::KbEscape #Keyboard Escape
      self.close
    when Gosu::MsLeft
      handle_mouse_click
    when Gosu::Kb1
      animation_for_rolling_die(1)
    when Gosu::Kb2
      animation_for_rolling_die(2)
    when Gosu::Kb3
      animation_for_rolling_die(3)
    when Gosu::Kb4
      animation_for_rolling_die(4)
    when Gosu::Kb5
      animation_for_rolling_die(5)
    when Gosu::Kb6
      animation_for_rolling_die(12345)
    end
  end
  def update
  end
  def draw
    unpack_info_for_gosu
    @roll_button=Gosu::Image.from_text(self,"GO","Times_New_Roman",50)
    @roll_button.draw(425,425,1)
    @selection_text=Gosu::Image.from_text(self,"#{@chosen_dice}","Times_New_Roman",30)
    @selection_text.draw(425,25,1)
    if @roll_animation !=0
      @dice_set.roll_dice
      @roll_animation-=1
    end
    n=0
    for die in @dice_set
      @die_face[die].draw(415+n,525,1)
      n+=80
    end
    draw_quad(0,0,0xffffffff,0,600,0xffffffff,800,600,0xffffffff,800,0,0xffffffff)
    draw_quad(1,1,0xff000000,1,599,0xff000000,399,599,0xff000000,399,1,0xff000000)
    draw_quad(400,1,0xff000000,400,399,0xff000000,799,399,0xff000000,799,1,0xff000000)
    draw_quad(400,400,0xff000000,400,500,0xff000000,532,400,0xff000000,532,500,0xff000000)#GO
    draw_quad(533,400,0xff000000,533,500,0xff000000,665,400,0xff000000,665,500,0xff000000)#YES
    draw_quad(666,400,0xff000000,666,500,0xff000000,799,400,0xff000000,799,500,0xff000000)#NO
    draw_quad(400,500,0xffffffff,800,500,0xffffffff,400,600,0xffffffff,800,600,0xffffffff)
    draw_quad(400,501,0xff000000,799,501,0xff000000,400,599,0xff000000,799,599,0xff000000)
    for num in 0..16
      box_for_score(num)
    end
  end
end

class Game
  attr_accessor :info_for_gosu
  def initialize
    @data={:score => 0, :slot => 0, :section => "", :dice => [], :name => ""}
    @dice=Dice_set.new(@data)
    @game_sheet=Game_sheet.new(@data)
    @info_for_gosu={:dice_scores => @dice.dice_scores, :upper_slots => @game_sheet.upper_section, :lower_slots => @game_sheet.lower_section, :upper_score => @game_sheet.upper_score, :lower_score => @game_sheet.lower_score, :total_score => @game_sheet.total_score}
    @name=""
    @section=@data[:section]
    @name=@data[:name]
    @reroll=@data[:reroll]
    run
  end
  def ask_for_reroll
    puts "Which dice would you like to re-roll?"
    print "enter integers 1-5 or nothing, do not seperate with spaces:"
    reroll = gets.chomp
    @dice.set_reroll(reroll)
  end
  def ask_for_section
    puts "which section would you like to enter into? (upper/lower)"
    section = gets.chomp
    @game_sheet.set_section(section)
  end
  def ask_for_slot
    puts "which slot number would you like to put the score into?"
    if @section == "upper"
      puts "upper: 1:aces 2:twos 3:threes 4:fours 5:fives 6:sixes"
    else
      puts "lower: 1:three/kind 2:four/kind 3:full house 4:sm straight 5:lg strait 6:chance 7:yatzee!"
    end
    slot = gets.chomp
    @game_sheet.set_slot(slot)
  end
  def turn
    @dice.reset
    @dice.roll_dice
    2.times {
            ask_for_reroll
            @dice.roll_dice
            }
    feedback_from_player
    @game_sheet.calculate_lower_score
    @game_sheet.calculate_upper_score
    @game_sheet.calculate_total_score
    @game_sheet.draw(@data)
  end
  def choose_another_slot
    puts "You can't do that! Please enter another slot."
    print "Your score was: "
    puts " #{@dice.draw}"
    feedback_from_player
  end
  def feedback_from_player
    ask_for_section
    ask_for_slot
    get_dice_scores
    @game_sheet.calculate_slot_score
    if @game_sheet.is_slot_valid
      @game_sheet.enter_score(@data)
    else
      if @game_sheet.is_slot_occupied==true#slot is empty
        choose_another_slot
      else
        puts "cannot enter this score here, would you like to enter a 0? (yes/no)"
        input=gets.chomp
        if input=="yes"
          @game_sheet.enter_zero(@data)
        else 
          choose_another_slot
        end
      end
    end
  end
  def run
    @game_sheet.draw(@data)
    until @game_sheet.is_game_over==true do turn end
  end
  def get_dice_scores
    @data[:dice_numbers]=@dice.dice_scores
  end
end

class Game_sheet
  attr_accessor :upper_section, :lower_section, :upper_score, :lower_score, :total_score
  def initialize(data)
    @data=data
    @name=@data[:name]
    @upper_section=[["Aces",""],["Twos", ""],["Threes", ""],["Fours", ""],["Fives", ""],["Sixes", ""]]
    @lower_section=[["Three of a Kind",""],["Four of a kind",""],["Full House",""],["Small Sraight",""],["Large Straight",""],["Chance",""],["Yatzee",""]]
    @upper_score=["Total",""]
    @lower_score=["Total",""]
    @total_score=["Grand Total",""]
    @slot=@data[:slot]
    @score=@data[:score]
    @section=@data[:section]
  end
  def draw(data)
    puts "______________________________"
    puts
    puts "Yatzee"
    #puts "#{@name}"
    puts
    puts
    puts "Upper Section"
    puts
    for score_space in @upper_section
      puts "#{score_space[0]}: #{score_space[1]}"
    end
    puts
    puts "#{@upper_score[0]}: #{@upper_score[1]}"
    puts
    puts "Lower Section"
    puts
    for score_space in @lower_section
      puts "#{score_space[0]}: #{score_space[1]}"
    end
    puts
    puts "#{@lower_score[0]}: #{@lower_score[1]}"
    puts
    puts "#{@total_score[0]}: #{@total_score[1]}"
    puts"________________________________"
  end
  def enter_score(data)
    if @section=="upper"
      @upper_section[@slot][1]=@score
    elsif @section=="lower"
      if @slot==6
        thing=@lower_section[@slot.to_i][1]
        if thing == ""
          @lower_section[@slot.to_i][1] = @score
        else
          @lower_section[@slot.to_i][1] += @score
        end
      else
        @lower_section[@slot.to_i][1] =@score
      end
    end
  end
  def enter_zero(data)
    if @section=="upper"
      @upper_section[@slot][1]=0
    elsif @section=="lower"
      @lower_section[@slot][1]=0
    end
  end
  def calculate_slot_score
    score=0
    @dice=@data[:dice_numbers]
    if @section=="upper"
      slot_num=(@slot+1)
      @dice.each {|num|
        if num == slot_num
          score += num
        end}
    else
      case @slot
      when 0..1 #three/four of a kind
        @dice.each {|num| score+=num } 
      when 5 #chance
        @dice.each {|num| score+=num }
      when 2 #full house
        score=25
        #set
      when 3 #small straight
        score=30
        #set
      when 4 #large straight
        score=40
        #set
      when 6 #yatzee  
        score=50
        #set
      end
    end
    @score=score
  end
  def set_slot(slot)
    @slot=slot.to_i-1
  end
  def set_section(section)
    @section=section
  end
  def is_slot_valid
    if @section=="upper"
      return @upper_section[@slot][1] == ""
    elsif @section=="lower"
      return false unless @lower_section[@slot.to_i][1] == ""
      if @slot==6
        return true if @dice-[@dice[0]]==[]
      else
        #return true if 
        case @slot.to_i
        when 0 #three of a kind
          for die in @dice
            if (@dice-[die]).length<=2
              return true
            end
          end
        when 1 #four of a kind
          for die in @dice
            if (@dice-[die]).length<=1
              return true
            end
          end
        when 2 #full house
          nums_left1=@dice - [@dice[0]]
          nums_left2=nums_left1 - [nums_left1[0]]
          if nums_left2==[]
            return true
          end
        when 3 #small straight
          if ([1,2,3,4] - @dice == []) or ([2,3,4,5] - @dice == []) or ([3,4,5,6] - @dice == []) then return true
          end
        when 4 #large straight
          if ([1,2,3,4,5] - @dice == []) or ([2,3,4,5,6] - @dice == []) then return true 
          end
        when 5 #chance
          return true
        end
      end
    else
      puts "slot_invalid"
      return false
    end
  end
  def is_slot_occupied
    return false if @slot[1]==""
    return true
  end
  def calculate_lower_score
    lower_score=0
    for space in @lower_section
      lower_score += space[1].to_i
    end
    @lower_score[1]=lower_score
  end
  def calculate_upper_score
    upper_score=0
    for space in @upper_section
     upper_score += space[1].to_i
    end
    @upper_score[1]=upper_score
  end
  def calculate_total_score
    @total_score[1]=(@upper_score[1]+@lower_score[1])
  end
  def is_game_over
    number_of_spaces_filled=0
    number_of_spaces=0
    for score in @upper_section
      if score[1]!=""
        number_of_spaces_filled+=1
      end
      number_of_spaces+=1
    end
    for score in @lower_section
      if score[1]!=""
        number_of_spaces_filled+=1
      end
      number_of_spaces+=1
    end
    if number_of_spaces_filled==number_of_spaces
      puts "game over"
      return true
    else
      return false
    end
  end
end

class Dice_set
  attr_accessor :dice_scores
  def initialize(data)
    @data=data
    @dice_scores=[0,0,0,0,0]
    @dice_to_be_rolled=@data[:reroll]
  end
  def draw
    print @dice_scores
    puts
  end
  def set_reroll(reroll)
    @dice_to_be_rolled=reroll
  end
  def roll_dice
    dice_to_roll=@dice_to_be_rolled.split("")
    dice_int=[]
    for die in dice_to_roll
      dice_int.push(die.to_i)
    end
    for die in dice_int 
      @dice_scores[die-1]=rand(1..6)
    end
    draw
    return @dice_scores
  end
  def reset
    @dice_to_be_rolled="12345"
  end
end

#game=Mothership.new
#game.show