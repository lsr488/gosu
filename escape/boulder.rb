class Boulder
  SPEED_LIMIT = 500
  FRICTION = 0.7
  ELASTICITY = 0.95

  attr_reader :body, :width, :height

  def initialize(window, x, y)
    @body = CP::Body.new(400, 4000)
    @body.p = CP::Vec2.new(x, y)
    @body.v_limit = SPEED_LIMIT # changing this number can make gameplay easier or harder
    bounds = [CP::Vec2.new(-13, -6),
               CP::Vec2.new(-16, -4),
               CP::Vec2.new(-16, 6),
               CP::Vec2.new(-3, 12),
               CP::Vec2.new(8, 12),
               CP::Vec2.new(13, 10),
               CP::Vec2.new(16, 3),
               CP::Vec2.new(16, -4),
               CP::Vec2.new(10, -9),
               CP::Vec2.new(2, -11)]
    shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0,0))
    shape.u = FRICTION
    shape.e = ELASTICITY
    @width = 32
    @height = 32
    window.space.add_body(@body)
    window.space.add_shape(shape)
    @boulder_image = Gosu::Image.new('images/boulder.png')
    @body.apply_impulse(CP::Vec2.new(rand(100000) - 50000, 100000), CP::Vec2.new(rand * 0.8 - 0.4, 0))
  end

  def draw
    @boulder_image.draw_rot(@body.p.x, @body.p.y, 1, @body.angle * (180.0 / Math::PI))
  end

  def quake
    @body.apply_impulse(CP::Vec2.new(rand(100000) - 50000, 100000), CP::Vec2.new(rand*0.8 - 0.4, 0))
  end

end
