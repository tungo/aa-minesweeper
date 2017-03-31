require_relative "board.rb"
require_relative "tile.rb"
require "byebug"

class MineSweeper
  attr_accessor :board

  def initialize
    @board = Board.default_board
  end

  def play

    until over?
      play_turn
    end
    display

    # until board.over?
    # play turn
  end

  def play_turn
    display
    flag, pos = get_input
    if flag == 'y'
      place_flag(pos)
    else
      @board.click_tile(get_input)
    end
  end

  def get_input
    puts "Do you want to place flag? (y,n)"
    flag = gets.chomp

    puts "What position do you want to play position? (x,y)"
    pos = translate(gets.chomp)

    [flag, pos]
  end

  def place_flag(pos)
    board.update_flag(pos)
  end

  def translate(pos)
    pos.split(',').map(&:to_i)
  end

  def display
    board.render
  end

  def over?
    board.won? or board.game_over?
  end

end

if __FILE__ == $PROGRAM_NAME
  MineSweeper.new.play
end
