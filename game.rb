require 'byebug'
require_relative 'board.rb'

class Minesweeper
  attr_reader :board
  def self.from_file(filename)
    raise "not a proper file" unless File.file?(filename)
    file = File.open(filename, "rb")
    board = Marshal.load(file)
    file.close
    self.new(0, board)
  end

  def initialize(n, board=nil)
    if board.nil?
      @board = Board.new(n) 
    else
      @board = board
    end
    @over = false

    play until over? 
    system('clear')
    @board.render
    @win ? (puts "you won!") : (puts "you lost!")
  end

  def play
    system('clear')
    @board.render

    puts "Please enter a command, reveal or flag, along with the position, like this: r0,0"
    input = gets.chomp
    until valid_input?(input)
      puts "Please try again"
      input = gets.chomp
    end

    case @last_move[0]
    when "r"
      @over = true unless @board.reveal(@last_move[1])
    when "f"
      @board.flag(@last_move[1])
    when "S"
      file = File.new("game", "w+b")
      file.write(Marshal.dump(@board))
      file.close

      puts "game saved!"
      @over = true
    else
      raise "fatal"
    end
  end

  def valid_input?(str)
    return false unless str.length == 4 || str.length == 1
    command = str.chars.shift
    return false unless command == "r" || command == "f" || command == "S"
    loc_parse = str[1..-1]
    location = loc_parse.length == 0 ? [] : str[1..-1].split(",").map(&:to_i)
    return false unless location.all? { |ele| ele.is_a?(Integer) }
    @last_move = [command, location]
    true
  end

  def over?
    @win = board.fully_flagged?
    @over || @win
  end
end