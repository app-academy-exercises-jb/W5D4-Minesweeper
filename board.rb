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
  # 1-2 enumerables
  # 0-1 challenge problems
  # 1-2 recursion problems
  # 1 arr manipulation
  # 1 string manipulation
  # 1 search/sort

  def initialize(n)
    @grid = Array.new(n) { Array.new(n) { Tile.new } }
    @revealed_locations = []
    # 20% of grid will be bombs
    num_bombs = (@grid.length * @grid.length) / 6
    Board.fill_board(@grid, num_bombs)
    Board.parse_board(@grid)
  end

  def render
    puts "  #{(0..self.grid.length - 1).map(&:to_s).join("") }"
    self.grid.each_with_index do |row,idx|
      line = ''
      line += idx.to_s + " "
      row.each do |tile|
        line += tile.to_s
      end

      puts line
    end
  end

  def fully_flagged?
    @grid.each { |row|
      row.all? { |tile| tile.revealed == true && tile.correctly_flagged? } ? next : (return false)
    }
  end

  def reveal(location)
    @revealed_locations << location
    pos = @grid[location[0]][location[1]]
    return true if pos.flagged == true
    result = pos.reveal
    result == :B ? (return false) : (reveal_neighbors(location); return true)
  end

  def reveal_neighbors(location)
    locations = self.class.neighbors(location, grid[0].length-1) - @revealed_locations
    neighbors = locations.map { |loc| grid[loc[0]][loc[1]] }
    
    if neighbors.none?(&:bomb?)
      locations.each_with_index { |loc,idx| 
        reveal(loc)
        reveal_neighbors(loc)
      }
    end
  end

  def flag(location)
    @grid[location[0]][location[1]].flag
  end
end



