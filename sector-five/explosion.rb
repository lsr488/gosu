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
      @images[@image_index].draw(@x - @radius, @y - @radius, 2)
      @image_index += 1
    #@image_index allows you to iterate through each element of the @images array
    #and then you increment the @images_index number so you can move to the next element
    else
      @finished = true
    end
  end

end

#have explosions drift?
