require 'byebug'
require_relative 'board.rb'

class Minesweeper
  attr_reader :board
  def initialize(n)
    @board = Board.new(n)
    @over = false

    play until over? 
    system('clear')
    @board.render
    puts "you won!" if @win
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
    else
      raise "fatal"
    end
  end

  def valid_input?(str)
    return false unless str.length == 4
    command = str.chars.shift
    return false unless command == "r" or command == "f"
    location = str[1..-1].split(",").map(&:to_i)
    return false unless location.all? { |ele| ele.is_a?(Integer) }
    @last_move = [command, location]
    true
  end

  def over?
    @win = board.fully_flagged?
    @over || @win
  end
end