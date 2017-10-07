require 'gosu'

class WhackARuby < Gosu::Window

  def initialize 
    super(800, 600)
    self.caption = "Whack the Ruby!"
    @ruby_image = Gosu::Image.new('ruby.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0 #ruby is visible if positive, invisible if negative
  end #END initiliaze METHOD

  def update #move objects, user actions
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width/2 < 0
    @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height/2 < 0
    @visible -= 1 #subtracts 1 from @visible
    @visible = 30 if @visible < -10 && rand < 0.01 #makes ruby visible for 30 frames if @visible 
  end #END update METHOD

  def draw
    if @visible > 0
      @ruby_image.draw(@x - @width / 2, @y - @width / 2, 1)
    end
  end #END draw METHOD

end # END WhackARuby CLASS

window = WhackARuby.new
window.show
