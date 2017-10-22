class Camera
  attr_reader :x_offset, :y_offset

  def initialize(window, space_height, space_width)
    @window = window
    @space_height = space_height
    @window_height = window.height
    @space_width = space_width
    @window_width = window.width
    @x_offset_max = space_width - @window_width
    @y_offset_max = space_height - @window_height
  end


end # end CLASS
