require 'gosu'
class Game
def initialize
@data={:score => 0, :slot => 0, :section => "", :dice => [], :name => ""}
@dice=Dice_set.new(@data)
@game_sheet=Game_sheet.new(@data)
@name=""
@section=@data[:section]
@name=@data[:name]
@reroll=@data[:reroll]
run
end
def ask_for_name
print "What is your name? "
name=gets.chomp
@game_sheet.set_name(name)
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
def reset_game # doesn't do anything yet. Do I need it?
end
def run
ask_for_name
#ask player if they want to see the rules
@game_sheet.draw(@data)
until @game_sheet.is_game_over==true do turn end
end
def get_dice_scores
@data[:dice_numbers]=@dice.dice_scores
end
end
class Game_sheet
attr_accessor :upper_section, :lower_section
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
puts "#{@name}"
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
def set_name(name)
@name=name
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
Game.new