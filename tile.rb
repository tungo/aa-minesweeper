class Tile
  attr_reader :bomb_count

  def initialize(bomb = false)
    @bomb = bomb
    @reveal = false
    @flag = false
  end

  def bomb?
    @bomb
  end

  def revealed?
    @reveal
  end

  def flag?
    @flag
  end

  def click
    @reveal = true
    @flag = false
  end

  def add_flag
    @flag = true unless revealed?
  end

  def remove_flag
    @flag = false
  end

  def adj_bombs(count)
    @bomb_count = count
  end

  def to_s
    if revealed? && bomb_count > 0
      bomb_count.to_s
    elsif revealed?
      "_"
    elsif flag?
      "F'"
    else
      "*"
    end
  end

end
