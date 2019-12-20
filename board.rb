require_relative 'tile.rb'
require 'byebug'

class Board

  attr_reader :grid

  def self.fill_board(grid, num)
    filled_positions = []
    until filled_positions.length == num
        pos = [rand(0...grid.length), rand(0...grid.length)]
        filled_positions << pos unless filled_positions.include?(pos)
    end
    filled_positions.each do |pos|
        grid[pos[0]][pos[1]].value = :B
    end
  end   

  def self.parse_board(grid)
    grid.each_with_index do |row, row_idx|
        row.each_with_index do |tile, tile_idx|
            next if tile.bomb? == true
            
            neighbors = Board.neighbors([row_idx,tile_idx], grid[0].length-1)
            
            num_bombs = 0
            neighbors.each do |pos|
              t = grid[pos[0]][pos[1]]
              num_bombs += 1 if t.bomb?
            end

            tile.value = num_bombs == 0 ? "_" : num_bombs
        end
    end
  end

  # 1-2 enumerables
  # 0-1 challenge problems
  # 1-2 recursion problems
  # 1 arr manipulation
  # 1 string manipulation
  # 1 search/sort

  def self.neighbors(tile_position, size)
    positions = []
    
    x, y = tile_position[0], tile_position[1]
    positions << [x-1, y] unless x == 0
    positions << [x+1, y] unless x == size
    positions << [x, y-1] unless y == 0
    positions << [x, y+1] unless y == size

    positions << [x-1, y-1] unless x == 0 || y == 0
    positions << [x-1, y+1] unless x == 0 || y == size
    positions << [x+1, y-1] unless y == 0 || x == size
    positions << [x+1, y+1] unless y == size || x == size

    positions
  end

  def initialize(n)
    @grid = Array.new(n) { Array.new(n) { Tile.new } }
    
    # 20% of grid will be bombs
    num_bombs = (@grid.length * @grid.length) / 6
    Board.fill_board(@grid, num_bombs)
    Board.parse_board(@grid)
  end

  def render
    self.grid.each do |row|
      line = ''
      row.each do |tile|
        print tile#.value.to_s
      end

      puts line
    end
  end

end



