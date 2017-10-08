class Explosion
  attr_reader :x, :y, :radius, :finished

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @radius = 30
    @images = Gosu::Image.load_tiles('images/explosions.png', 60, 60)
    @image_index = 0
    @finished = false
  end

  def draw
    if @image_index < @images.count
      #@image_index allows you to iterate through each element of the @images array
      @images[@image_index].draw(@x - @radius, @y - @radius, 2)
      #and then you increment the @images_index number so you can move to the next element
      @image_index += 1
    else
      @finished = true
    end
  end

end

#have explosions drift?
