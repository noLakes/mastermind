
#contains and displays color value
class Pin
  attr_reader :val, :txt
  @@PIN_COLORS = ['R', 'G', 'B', 'W', 'Y', 'P']

  def initialize(color=' ')
    @val = color
  end

  def Pin.build(num)
    @container = {}
    num.times {|count| @container[count + 1] = self.new(' ')}
    return @container
  end

  def txt
    return ['[', ' ', "#{@val}", ' ', ']'].join('')
  end

  def set_val=(color)
    @val = color
  end

  def Pin.colors
    return @@PIN_COLORS
  end
end

#smaller version of pin used for guess feedback (X = correct pos+col / O = correct col)
class Clue < Pin
  @@CLUE_COLORS = ['X', 'O']

  def initialize(color=' ')
    @val = color
  end

  def txt
    return ['[', "#{@val}", ']'].join('')
  end

  def Clue.colors
    return @@CLUE_COLORS
  end
end

#holds and displays pins
class Row
  attr_reader :pins, :clues, :number

  @@row_count = 0

  def initialize(pins=4, clues=4)
    @number = (@@row_count + 1).to_s + '  '
    @number << ' ' if @number.length == 3
    @@row_count += 1

    @pins = {}.merge!(Pin.build(pins))
    @clues = {}.merge!(Clue.build(clues))
  end

  def Row.build(num, clues=4)
    @container = {}
    num.times {|count| @container[count + 1] = self.new(4, clues)}
    return @container #.to_a.reverse.to_h if you want....
  end

  def set_pin_val(pin, val)
    @pins[pin].set_val = val
  end

  def set_clue_val(clue, val)
    @clues[clue].set_val = val
  end

  def getPin(pin)
    return @pins[pin].val
  end

  def getClue(clue)
    return @clues[clue].val
  end

  def addGuess(guess)
    
  end

  def addClue(clue)
   
  end

  def txt
    row = [@number, ' ']
    @pins.each_value {|pin| row << pin.txt}
    unless @clues.length.zero?
      row << ' --------- '
      @clues.each_value {|clue| row << clue.txt}
    end
    return row.join
  end

end

module Codes
  
  def test(code)
    if code.length == 4
      if code.all? {|char| Pin.colors.include?(char)}
        return true
      else
        puts "Error: Colors must be included in #{Pin.colors.join(' ')}"
        return false
      end
    else
      puts 'Error: Code incorrect length!'
      return false
    end
  end

end

class Code 
  attr_reader :cracked, :row
  def initialize(pin1=Pin.colors.sample, pin2=Pin.colors.sample, 
                pin3=Pin.colors.sample, pin4=Pin.colors.sample)
    @row = Row.new(4, 0)
    @row.set_pin_val(1, pin1)
    @row.set_pin_val(2, pin2)
    @row.set_pin_val(3, pin3)
    @row.set_pin_val(4, pin4)
    @cracked = true
  end

  def getPin(pin)
    return @row[pin].val
  end

  def txt
    if self.cracked?
      return reveal
    else
      return 'CODE [ ? ][ ? ][ ? ][ ? ]'
    end
  end

  def cracked?
    return @cracked
  end

  def crack(guess)
    @guess = [pin1, pin2, pin3, pin4]

    #if crack = true return

  end

  private
  def reveal
    code = ['CODE ']
    @row.pins.each_value {|pin| code << pin.txt}
    return code.join
  end
 
end

class Board
  attr_reader :rows

  def initialize(rows=12)
    @rows = {}.merge!(Row.build(rows))
    @code = {}
  end

  def addCode(code)
    @code[:code] = code
    @rows.merge!(@code)
  end

  def txt
    board = @rows.to_a.reverse.to_h
    text = ['------------- M A S T E R M I N D -------------', "\n\n"]

    board.each_value do |val|
      text << val.txt
      text << "\n"
    end
    text << "\n"
    return text.join
  end

end

class Master
  include Codes
  attr_reader :name, :humanity
  def initialize(humanity=false, name='Master')
    @name = name
    @human = humanity
    @code = []
  end

  def makeCode
    if @human == true
      until test(@code) do
        puts "Please enter the 4 colors for your code. Colors: #{Pin.colors.join(' ')}"
        @code = gets.chomp.upcase.split(//)
      end
      return Code.new(@code[0], @code[1], @code[2], @code[3])
    else
      puts "beep boop. code made!"
      return Code.new
    end
  end

end

class Breaker
  include Codes
  attr_reader :name, :humanity
  def initialize(humanity=true, name='Breaker')
    @name = name
    @human = humanity
    @guess = []
  end

  def guess
    if @human == true
      until test(@guess) do
        puts "Please enter the 4 colors for your guess. Colors: #{Pin.colors.join(' ')}"
        @guess = gets.chomp.upcase.split(//)
      end
      return Code.new(@guess[0], @guess[1], @guess[2], @guess[3])
    else
      #AI STUFF
      puts "Beep boop, random guess (for now)"
      return Code.new
    end
  end

end

class Game
  include Codes
  attr_reader :board, :players, :turn
  def initialize(turns=12, master=false, breaker=true)
    @board = Board.new(turns)
    @players = {:master => Master.new(master), :breaker => Breaker.new(breaker)}
    @turn = 0
  end

  def play
    puts "\n\nWelcome to MASTERMIND! Lets begin by setting a code."
    @board.addCode(@players[:master].makeCode)
    turn
  end

  private
  def turn
    @turn += 1
    puts @board.txt
    puts "Turn: #{@turn} / Enter your guess below!"
    guess = @players[:breaker].guess
    @board.rows[@turn].addGuess(guess)
    turn
  end
end


# CAUTION: test are below. working code ^overhead^

x = Game.new(12, false, true)
x.play


#to do next: you were stuck on the addGuess methods at the end of Game:turn (also, maybe refactor the getValue methods in your classes)
#logic of a turn (updating txt at end), entering and evaluating a guess,