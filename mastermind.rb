COLORS = ['R', 'G', 'B', 'W', 'Y', 'O']

#contains and displays color value
class Pin
  attr_reader :val, :txt
  @@COLORS = ['R', 'G', 'B', 'W', 'Y', 'O']

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

end

#smaller version of pin used for guess feedback (X = correct pos+col / O = correct col)
class Clue < Pin
  @@COLORS = ['X', 'O']

  def initialize(color=' ')
    @val = color
  end

  def txt
    return ['[', "#{@val}", ']'].join('')
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

  def initialize(pin1=COLORS.sample, pin2=COLORS.sample, 
                pin3=COLORS.sample, pin4=COLORS.sample)
    @row = Row.new(4, 0)
    @row.set_pin_val(1, pin1)
    @row.set_pin_val(2, pin2)
    @row.set_pin_val(3, pin3)
    @row.set_pin_val(4, pin4)
    @cracked = false
  end

  def txt
    if self.cracked?
      return self.reveal
    else
      return 'CODE [ ? ][ ? ][ ? ][ ? ]'
    end
  end

  def cracked?
    return @cracked
  end

  def crack(pin1, pin2, pin3, pin4)
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

  def addCode(pin1, pin2, pin3, pin4)
    @code[:code] = Code.new(pin1, pin2, pin3, pin4)
    @rows.merge!(@code)
  end

  def txt
    board = @rows.to_a.reverse.to_h
    text = []

    board.each_value do |val|
      text << val.txt
      text << "\n"
    end
    return text.join
  end

end




# CAUTION: test are below. working code ^overhead^


x = Board.new(12)
x.addCode('G', 'R', 'B', 'Y')
puts x.txt
