class Wall
  FRICTION = 0.7
  ELASTICITY = 0.2

  def initialize(window, x, y, width, height)
    space = window.space
    @x = x
    @y = y
    @width = width
    @height = height
    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(x, y)
    @bounds = [
      CP::Vec2.new(-width / 2, -height / 2), # -400, -400. (0, 0) is the CENTER of the screen
      CP::Vec2.new(-width / 2, height / 2), # -400, 400
      CP::Vec2.new(width / 2, height / 2), # 400, 400
      CP::Vec2.new(width / 2, -height / 2), # 400, -400
    ]
    @shape = CP::Shape::Poly.new(@body, @bounds, CP::Vec2.new(0,0))
    @shape.u = FRICTION
    @shape.e = ELASTICITY
    space.add_shape(@shape)
  end
end
