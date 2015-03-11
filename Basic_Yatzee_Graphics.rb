require 'gosu'
class Mothership < Gosu::Window
  def initialize
    @data={:score => 0, :slot => 0, :section => "", :dice => [], :name => ""}
    @dice_set=Dice_set.new(@data)
    #@game=Game.new(@data)
    super(800,600,false) #(width in pixles,height in pixles,true/false for fullscreen)
    self.caption="Yatzee"
    @die_face=[]
    @die_face[1]=Gosu::Image.new(self,"die1.png",false)
    @die_face[2]=Gosu::Image.new(self,"die2.png",false)
    @die_face[3]=Gosu::Image.new(self,"die3.png",false)
    @die_face[4]=Gosu::Image.new(self,"die4.png",false)
    @die_face[5]=Gosu::Image.new(self,"die5.png",false)
    @die_face[6]=Gosu::Image.new(self,"die6.png",false)
    @dice_set.reset
    @dice_set.roll_dice
    @roll_animation=0
    @roll_phase=true
    @chosen_dice=""
  end
  def needs_cursor?
    true
  end
  def animation_for_rolling_die(die)
    return if die==""
    @dice_set.set_reroll(die)
    @roll_animation=15
  end
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
  def handle_mouse_click
    if @roll_phase==true
      if in_dice_row(mouse_y)
        which_die(mouse_x)
      elsif in_button_row(mouse_y)
        which_button(mouse_x)
      end
    end
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
    @roll_button=Gosu::Image.from_text(self,"GO","Times_New_Roman",50)
    @roll_button.draw(425,425,1)
    @selection_text=Gosu::Image.from_text(self,"#{@chosen_dice}","Times_New_Roman",30)
    @selection_text.draw(425,25,1)
=begin # this makes an infinite reroll/draw loop
    @dice_set.reset
    @dice_set.roll_dice
=end
    if @roll_animation !=0
      @dice_set.roll_dice
      @roll_animation-=1
    end
    n=0
    for die in @dice_set.dice_scores
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
end #this works with Gosu
game=Mothership.new
game.show
#new stuff
