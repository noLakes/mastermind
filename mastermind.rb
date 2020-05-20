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

module CodeLogic
  
  def testCode(code)
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

  def make(human)
    code = []
    if human == true
      loop do
        puts "Please enter the 4 colors for your code. Colors: #{Pin.colors.join(' ')}"
        code = gets.chomp.upcase.split(//)
        break if testCode(code)
      end
      return Code.new(code[0], code[1], code[2], code[3])
    else
      puts "beep boop. code made!"
      return Code.new
    end
  end

  def evaluate(master, breaker)
    clues = []
    accum = []
    breaker.each_pair do |key, val|
      if master[key] == val
        clues << 'X'
        master.delete(key)
        breaker.delete(key)
      end 
    end
    breaker.each_value do |val|
      if master.value?(val)
        accum << val
        clues << 'O' if accum.count(val) <= master.values.count(val)
      end
    end
    return clues
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
    return @row.getPin(pin)
  end

  def getPins
    return {1 => @row.getPin(1), 2 => @row.getPin(2), 3 => @row.getPin(3), 4 => @row.getPin(4)}
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
  end

  def addCode(code)
    @rows.merge!({ :code => code })
  end

  def addGuess(row, code)
    i = 1
    until i == 5
      @rows[row].set_pin_val(i, code.getPin(i))
      i += 1
    end
  end

  def addClues(row, clues)
    i = 1
    until i > clues.length
      @rows[row].set_clue_val(i, clues[i - 1])
      i += 1
    end
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

class Player
  attr_reader :name, :human
  def initialize(humanity=false)
    @human = humanity
  end

end

class Game
  include CodeLogic
  attr_reader :board, :players, :turn, :turns
  
  def initialize(turns=12, masterHuman=false, breakerHuman=true)
    @board = Board.new(turns)
    @master = Player.new(masterHuman)
    @breaker = Player.new(breakerHuman)
    @turn = 1
    @turns = turns
  end

  def play
    puts "\n\nWelcome to MASTERMIND! Lets begin by setting a code."
    @board.addCode(make(@master.human))
    turn
  end

  private
  def turn
    puts @board.txt
    puts "Turn: #{@turn} / Enter your guess below!"
    guess = make(@breaker.human)
    @board.addGuess(@turn, guess) 
    clues = evaluate(@board.rows[:code].getPins, guess.getPins)
    @board.addClues(@turn, clues)
    if clues.length == 4 && clues.all?('X')
      puts @board.txt
      game_over("Game over! Breaker guessed the code in #{@turn} turns!")
    elsif @turn == @turns
      puts @board.txt
      game_over('Game over! Turn limit reached. Mastermind wins!')
    else
      @turn += 1
      turn
    end
  end

  def game_over(msg)
      puts msg
      sleep 1
      answer = ''
      loop do
        puts "Play again? [y/n]"
        answer = gets.chomp.downcase
        break if answer == 'y' or answer == 'n'
      end
      new_game if answer == 'y'
  end

  def new_game
    @board = Board.new(turns)
    @turn = 1
    play
  end
end

# CAUTION: test are below. working code ^overhead^
x = Game.new(12, false, true)
x.play