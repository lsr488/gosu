class Enemy
  attr_reader :x, :y, :radius

  def initialize(window)
    @radius = 20
    @x = rand(window.width - 2 * @radius) + @radius
    @y = 0 # top of window
    @image = Gosu::Image.new('images/enemy.png')
    @angle = rand(-5..5)
    @speed = rand(1..5)
    @window = window
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

  def move
    @y += @speed
    @x += @angle
    if @x > @window.width - @radius # right side
      @velocity_x = 0
      @x = @window.width - @radius
    end
    if @x < @radius # left side
      @velocity_x = 0
      @x = @radius
    end
    # if @y > @window.height - @radius # bottom edge
    #   @velocity_y = 0
    #   @y = @window.height - @radius
    # end
  end

end
