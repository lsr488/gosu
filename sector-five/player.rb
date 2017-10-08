class Player
  attr_reader :x, :y, :angle, :radius

  ROTATION_SPEED = 5
  ACCELERATION = 1
  FRICTION = 0.9

  def initialize(window)
    @x = 200
    @y = 400
    @angle = 0
    @image = Gosu::Image.new('images/ship.png')
    @velocity_x = 0
    @velocity_y = 0
    @radius = 20
    @window = window
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_right
    @angle += ROTATION_SPEED
  end

  def turn_left
    @angle -= ROTATION_SPEED
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= FRICTION
    @velocity_y *= FRICTION
    if @x > @window.width - @radius # right side
      @velocity_x *= -1 # ship bounces
      @x = @window.width - @radius
    end
    if @x < @radius # left side
      @velocity_x *= -1 # ship bounces
      @x = @radius
    end
    if @y > @window.height - @radius # bottom edge
      @velocity_y *= -1 # ship bounces
      @y = @window.height - @radius
    end
  end

end
