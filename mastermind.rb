
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

class Code 
  attr_reader :cracked, :row

  def initialize(pin1=Pin.colors.sample, pin2=Pin.colors.sample, 
                pin3=Pin.colors.sample, pin4=Pin.colors.sample)
    @row = Row.new(4, 0)
    @row.set_pin_val(1, pin1)
    @row.set_pin_val(2, pin2)
    @row.set_pin_val(3, pin3)
    @row.set_pin_val(4, pin4)
    @cracked = false
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
  attr_reader :name, :humanity
  def initialize(humanity=false, name='Master')
    @name = name
    @human = humanity
    @code = []
  end

  def makeCode
    if @human == true
      until checkCode(@code) do
        puts "Please enter the 4 colors for your code. Your options are: #{Pin.colors.join(' ')}"
        @code = gets.chomp.upcase.split(//)
      end
      return Code.new(@code[0], @code[1], @code[2], @code[3])
    else
      puts "beep boop. code made!"
      return Code.new
    end
  end

  def checkCode(code)
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

class Breaker
  attr_reader :name, :humanity
  def initialize(humanity=true, name='Breaker')
    @name = name
    @human = humanity
  end

  def try_solve
    #checks if human, asks you to input code guess, returns code guess as object with keys 1,2,3,4
  end

end

class Game
  
  def initialize(turns=12, master=false, breaker=true)
    @board = Board.new(turns)
    @players = {:master => Master.new(master), :breaker => Breaker.new(breaker)}
    @turn = 0
  end

  def play
    @board.addCode(@players[:master].makeCode) #adds a code to the board
  end

end


# CAUTION: test are below. working code ^overhead^

x = Game.new(12)
master = Master.new(false)
code = master.makeCode
puts code.txt

#to do next: add game start, logic of a turn (updating txt at end), entering and evaluating a guess,