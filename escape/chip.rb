class Chip
  RUN_IMPULSE = 400
  FLY_IMPULSE = 100
  JUMP_IMPULSE = 60000
  AIR_JUMP_IMPULSE = 1200
  SPEED_LIMIT = 400
  FRICTION = 0.9
  ELASTICITY = 0.2

  attr_reader :off_ground

  def initialize(window, x, y)
    @window = window
    space = window.space
    @player_images = Gosu::Image.load_tiles('images/chip.png', 40, 65)
    @player_image_index = 0
    @body = CP::Body.new(50, 100 / 0.0)
    @body.p = CP::Vec2.new(x, y)
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
    @off_ground = true
  end

  def x
    @body.p.x
  end

  def y
    @body.p.y
  end

  def draw
    case @action
    when :stand, :jump_right
      @player_images[0].draw_rot(@body.p.x, @body.p.y, 2, 0)
    when :run_right
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0)
      @player_image_index = (@player_image_index + 0.2) % 7
    when :run_left
      @player_images[@player_image_index].draw_rot(@body.p.x, @body.p.y, 2, 0, 0.5, 0.5, -1, 1)
      @player_image_index = (@player_image_index + 0.2) % 7
    when :jump_left
      @player_images[0].draw_rot(@body.p.x, @body.p.y, 2, 0, 0.5, 0.5, -1, 1)
    else
      @player_images[0].draw_rot(@body.p.x, @body.p.y, 2, 0)
    end
  end

  def move_right
    if @off_ground
      @action = :jump_right
      @body.apply_impulse(CP::Vec2.new(FLY_IMPULSE, 0), CP::Vec2.new(0,0))
    else
      @action = :run_right
      @body.apply_impulse(CP::Vec2.new(RUN_IMPULSE, 0), CP::Vec2.new(0,0))
    end
  end

  def move_left
    if @off_ground
      @action = :jump_left
      @body.apply_impulse(CP::Vec2.new(-FLY_IMPULSE, 0), CP::Vec2.new(0,0))
    else
      @action = :run_left
      @body.apply_impulse(CP::Vec2.new(-RUN_IMPULSE, 0), CP::Vec2.new(0,0))
    end
  end

  def jump
    if @off_ground
      @body.apply_impulse(CP::Vec2.new(0, -AIR_JUMP_IMPULSE),
                          CP::Vec2.new(0,0))
    else
      @body.apply_impulse(CP::Vec2.new(0, -JUMP_IMPULSE), CP::Vec2.new(0,0))
      if @action == :left
        @action = :jump_left
      else
        @action = :jump_right
      end
    end
  end

  def stand
    @action = :stand unless off_ground
  end

  def touching?(footing)
    x_diff = (@body.p.x - footing.body.p.x).abs
    y_diff = (@body.p.y + 30 - footing.body.p.y).abs
    x_diff < 12 + footing.width/2 and y_diff < 5 + footing.height/2
  end

  def check_footing(things)
    @off_ground = true
    things.each do |thing|
      @off_ground = false if touching?(thing)
    end
    if @body.p.y > 765
      @off_ground = false
    end
  end

end
