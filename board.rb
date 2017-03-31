require_relative "tile.rb"


class Board
  attr_reader :grid

  def initialize(grid)
    @grid = grid
    @bomb_pos = []
    populate
  end

  def [](pos)
    row,col = pos
    grid[row][col]
  end

  def []=(pos,val)
    row,col = pos
    grid[row][col] = val
  end

  def add_bomb_count
    grid.each_with_index do |array, row|
      array.each_index do |col|
        bomb_count = adjacent_tiles([row,col]).count do |adj_pos|
          self[adj_pos].bomb?
        end
        self[[row,col]].adj_bombs(bomb_count)
      end
    end
  end

  def click_tile(pos)
    self[pos].click
    if self[pos].bomb?
      return
    elsif self[pos].bomb_count > 0
      return
    elsif self[pos].bomb_count == 0
      adjacent_tiles(pos).each do |adj_pos|
        click_tile(adj_pos) unless self[adj_pos].revealed?
      end
    end
  end

  def game_over?
    @grid.flatten.any? { |tile| tile.bomb? && tile.revealed? }
  end

  def won?
    not_bomb = @grid.flatten.reject { |tile| tile.bomb? }
    not_bomb.all? { |tile| tile.revealed? }
  end

  def update_flag(pos)
    self[pos].add_flag
  end

  def adjacent_tiles(pos)
    row, col = pos
    tile_arr = []
    (row-1..row+1).each do |ro|
      (col-1..col+1).each do |co|
        tile_arr << [ro,co] if valid_tile?([ro,co])
      end
    end
    tile_arr.delete(pos)
    tile_arr
  end

  def valid_tile?(pos)
    row, col = pos
    row >= 0 && row <= 8 && col >= 0 && col <= 8
  end

  def populate
    grid.each_with_index do |array, row|
      array.each_index { |col| grid[row][col] = Tile.new }
    end

    place_bomb
    add_bomb_count
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, idx|
      puts "#{idx} #{row.map(&:to_s).join(' ')}"
    end
  end

  def place_bomb
    until @bomb_pos.length == 5
      row, col = rand(9), rand(9)
      unless @bomb_pos.include? [row,col]
        grid[row][col].add_bomb
        @bomb_pos << [row,col]
      end
    end
  end

  def self.default_board
    empty_grid = Array.new(9) { Array.new(9) }
    self.new(empty_grid)
  end

end
