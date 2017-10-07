require 'gosu'

class WhackARuby < Gosu::Window

  def initialize 
    super(800, 600)
    self.caption = "Whack the Ruby!"
    @image = Gosu::Image.new('ruby.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 5
    @velocity_y = 5
  end #END initiliaze METHOD

  def update #move objects, user actions
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width/2 < 0
    @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height/2 < 0
  end #END update METHOD

  def draw
    @image.draw(@x - @width / 2, @y - @width / 2, 1)
  end #END draw METHOD

end # END WhackARuby CLASS

window = WhackARuby.new
window.show
