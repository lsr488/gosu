class Bullet
  attr_reader :x, :y, :radius
  SPEED = 5

  def initialize(window, x, y, angle)
    @window = window
    @x = x
    @y = y
    @direction = angle
    @image = Gosu::Image.new('images/bullet.png')
    @radius = 3
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

  def move
    @x += Gosu.offset_x(@direction, SPEED)
    @y += Gosu.offset_y(@direction, SPEED)
  end

  def onscreen?
    right = @window.width + @radius
    left = -@radius
    top = -@radius
    bottom = @window.height + @radius
    @x > left && @x < right && @y > top && @y < bottom 
  end

end