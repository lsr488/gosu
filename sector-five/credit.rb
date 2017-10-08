class Credit

  attr_reader :y
  SPEED = 1

  def initialize(window, text, x, y)
    @window = window
    @x = x
    @y = @initial_y = y
    @text = text
    @font = Gosu::Font.new(24)
  end

  def draw
    @font.draw(@text, @x, @y, 1)
  end

  def move
    @y -= SPEED
  end

  def reset
    @y = @initial_y
  end

end