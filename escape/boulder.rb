class Boulder
  SPEED_LIMIT = 500
  attr_reader :body, :width, :height

  def initialize
    @body = CP::Body.new(400, 4000)
    @body.p = CP::Vec2.new(x, y)
    @body.v_limit = SPEED_LIMIT
  end

end