class Chip
  RUN_IMPULSE = 600
  FLY_IMPULSE = 60
  JUMP_IMPULSE = 36000
  AIR_JUMP_IMPULSE = 1200
  SPEED_LIMIT = 400
  FRICTION = 0.7
  ELASTICITY = 0.2

  attr_reader :off_ground

  def initialize(window, x, y)
    @window = window
    space = window.space
    @player_images = Gosu::Image.load_tiles('images/chip.png', 40, 65)
    @body = CP::Body.new(50, 100 / 0.0)
    @body.v_limit = SPEED_LIMIT
    bounds = [
      CP::Vec2.new(-10, -32),
      CP::Vec2.new(-10, 32),
      CP::Vec2.new(10, 32),
      CP::Vec2.new(10, -32),
    ]
    shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0,0))
    shape.u = FRICTION
    shape.e = ELASTICITY
    space.add_body(@body)
    space.add_shape(shape)
    @action = :stand
    @player_image_index = 0
    @off_ground = true
  end

  def draw
    case @action
    when :stand, :jump_right
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0)
    when :run_right
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0)
      @player_image_index = (@player_image_index + 0.2) % 7
    when :run_left
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0, 0.5, 0.5, -1, 1)
      @player_image_index = (@player_image_index + 0.2) % 7
    when :jump_left
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0, 0.5, 0.5, -1, 1)
    else
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0)
    end
  end

end
